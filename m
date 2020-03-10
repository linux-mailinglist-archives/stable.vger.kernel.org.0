Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B93D417FBCD
	for <lists+stable@lfdr.de>; Tue, 10 Mar 2020 14:17:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731688AbgCJNNX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Mar 2020 09:13:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:36114 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731537AbgCJNNW (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 10 Mar 2020 09:13:22 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C4215208E4;
        Tue, 10 Mar 2020 13:13:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583846002;
        bh=z05/4+UxW29/S/5/yxpVB9fWHn4FRXryPt0rocly8Vo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oQ0xR0aQVTiMQJjwYeiFWLOQ/P9wK02+9XPqItcc3Qa7np+Lh5oh2DuUEDQwEoVPx
         EPo9Y/UGapWhqLiDMLRWFyh5LLXOKLDeyZNdzgGayj7nvlBuyniX1LgB7VxT2MmPgv
         hN0XxBzpJ+pXy2JYmj3hy2pMSTFWui8JgBGlYzUs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Nicolas Dufresne <nicolas@ndufresne.ca>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Subject: [PATCH 4.19 51/86] media: v4l2-mem2mem.c: fix broken links
Date:   Tue, 10 Mar 2020 13:45:15 +0100
Message-Id: <20200310124533.550507720@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200310124530.808338541@linuxfoundation.org>
References: <20200310124530.808338541@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hans Verkuil <hverkuil-cisco@xs4all.nl>

commit 316e730f1d8bb029fe6cec2468fb2a50424485b3 upstream.

The topology that v4l2_m2m_register_media_controller() creates for a
processing block actually created a source-to-source link and a sink-to-sink
link instead of two source-to-sink links.

Unfortunately v4l2-compliance never checked for such bad links, so this
went unreported for quite some time.

Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Reported-by: Nicolas Dufresne <nicolas@ndufresne.ca>
Cc: <stable@vger.kernel.org>      # for v4.19 and up
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/media/v4l2-core/v4l2-mem2mem.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/media/v4l2-core/v4l2-mem2mem.c
+++ b/drivers/media/v4l2-core/v4l2-mem2mem.c
@@ -787,12 +787,12 @@ int v4l2_m2m_register_media_controller(s
 		goto err_rel_entity1;
 
 	/* Connect the three entities */
-	ret = media_create_pad_link(m2m_dev->source, 0, &m2m_dev->proc, 1,
+	ret = media_create_pad_link(m2m_dev->source, 0, &m2m_dev->proc, 0,
 			MEDIA_LNK_FL_IMMUTABLE | MEDIA_LNK_FL_ENABLED);
 	if (ret)
 		goto err_rel_entity2;
 
-	ret = media_create_pad_link(&m2m_dev->proc, 0, &m2m_dev->sink, 0,
+	ret = media_create_pad_link(&m2m_dev->proc, 1, &m2m_dev->sink, 0,
 			MEDIA_LNK_FL_IMMUTABLE | MEDIA_LNK_FL_ENABLED);
 	if (ret)
 		goto err_rm_links0;


