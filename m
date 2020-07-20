Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 68B082267EA
	for <lists+stable@lfdr.de>; Mon, 20 Jul 2020 18:15:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387922AbgGTQPp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Jul 2020 12:15:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:56726 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388452AbgGTQPp (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Jul 2020 12:15:45 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D96222064B;
        Mon, 20 Jul 2020 16:15:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595261744;
        bh=Uv5flyql7EogvRvn4rbLtyNvjWQ4u+X8dHYmaD+qbfA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dyKTHbyK/6UrByCqx3a8OKN8KFoWZ0Fw3DTvXY7cgISH5Y6ChWEY97L0Nv7zJp3D9
         HnEUq2aWiZvf6BWK5Av/vyIK0Z+ZVHTfMGcEvy9mofCfJZ7KD47/WOKkjBmMHYUZ3o
         0zYMI7f+e2mp8due5owzC/967d2lYkUMy3mySXJc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Josip Pavic <Josip.Pavic@amd.com>,
        Aric Cyr <Aric.Cyr@amd.com>,
        Rodrigo Siqueira <Rodrigo.Siqueira@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 5.7 226/244] drm/amd/display: handle failed allocation during stream construction
Date:   Mon, 20 Jul 2020 17:38:17 +0200
Message-Id: <20200720152836.603503000@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200720152825.863040590@linuxfoundation.org>
References: <20200720152825.863040590@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Josip Pavic <Josip.Pavic@amd.com>

commit be73e608ae2711dc8a1ab8b9549d9e348061b2ee upstream.

[Why]
Failing to allocate a transfer function during stream construction leads
to a null pointer dereference

[How]
Handle the failed allocation by failing the stream construction

Cc: stable@vger.kernel.org
Signed-off-by: Josip Pavic <Josip.Pavic@amd.com>
Reviewed-by: Aric Cyr <Aric.Cyr@amd.com>
Acked-by: Rodrigo Siqueira <Rodrigo.Siqueira@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/amd/display/dc/core/dc_stream.c |   19 ++++++++++++++++---
 1 file changed, 16 insertions(+), 3 deletions(-)

--- a/drivers/gpu/drm/amd/display/dc/core/dc_stream.c
+++ b/drivers/gpu/drm/amd/display/dc/core/dc_stream.c
@@ -56,7 +56,7 @@ void update_stream_signal(struct dc_stre
 	}
 }
 
-static void dc_stream_construct(struct dc_stream_state *stream,
+static bool dc_stream_construct(struct dc_stream_state *stream,
 	struct dc_sink *dc_sink_data)
 {
 	uint32_t i = 0;
@@ -118,11 +118,17 @@ static void dc_stream_construct(struct d
 	update_stream_signal(stream, dc_sink_data);
 
 	stream->out_transfer_func = dc_create_transfer_func();
+	if (stream->out_transfer_func == NULL) {
+		dc_sink_release(dc_sink_data);
+		return false;
+	}
 	stream->out_transfer_func->type = TF_TYPE_BYPASS;
 	stream->out_transfer_func->ctx = stream->ctx;
 
 	stream->stream_id = stream->ctx->dc_stream_id_count;
 	stream->ctx->dc_stream_id_count++;
+
+	return true;
 }
 
 static void dc_stream_destruct(struct dc_stream_state *stream)
@@ -164,13 +170,20 @@ struct dc_stream_state *dc_create_stream
 
 	stream = kzalloc(sizeof(struct dc_stream_state), GFP_KERNEL);
 	if (stream == NULL)
-		return NULL;
+		goto alloc_fail;
 
-	dc_stream_construct(stream, sink);
+	if (dc_stream_construct(stream, sink) == false)
+		goto construct_fail;
 
 	kref_init(&stream->refcount);
 
 	return stream;
+
+construct_fail:
+	kfree(stream);
+
+alloc_fail:
+	return NULL;
 }
 
 struct dc_stream_state *dc_copy_stream(const struct dc_stream_state *stream)


