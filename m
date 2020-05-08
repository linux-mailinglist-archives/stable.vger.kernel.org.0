Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D98F71CAB3A
	for <lists+stable@lfdr.de>; Fri,  8 May 2020 14:41:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728354AbgEHMlg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 May 2020 08:41:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:36828 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728836AbgEHMlf (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 8 May 2020 08:41:35 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A02B321835;
        Fri,  8 May 2020 12:41:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588941695;
        bh=2dG/OHHGbktKhf8xB9OWzKVYPN3FmK95Ri9z0xkL55U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LLEiTBGqZBmRN/mpOkBwXnr1SqfBoBYqlA+5NvyVzcUaHSTk3f2rZqzyY1f2VxUny
         cdvb2Mfr39lRu8fsO7KVJBpJ6knFiUieguo5v4SEzXiQeuVvyJoZK1uUuTvyCzJBQU
         ckLNH1VKVPwvYlh4G3eSGuUNXSH9nN4VuGJ9Toac=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        Dinesh Mirche <dinesh.mirche@intel.com>,
        Vinod Koul <vinod.koul@intel.com>,
        Mark Brown <broonie@kernel.org>
Subject: [PATCH 4.4 134/312] ASoC: Intel: pass correct parameter in sst_alloc_stream_mrfld()
Date:   Fri,  8 May 2020 14:32:05 +0200
Message-Id: <20200508123133.928010716@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200508123124.574959822@linuxfoundation.org>
References: <20200508123124.574959822@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dan Carpenter <dan.carpenter@oracle.com>

commit d16a2b9f2465b5486f830178fbfb7d203e0a17ae upstream.

"data" is always NULL in this function.  I think we should be passing
"&data" to sst_prepare_and_post_msg() instead of "data".

Fixes: 3d9ff34622ba ('ASoC: Intel: sst: add stream operations')
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Tested-by: Dinesh Mirche <dinesh.mirche@intel.com>
Acked-by: Vinod Koul <vinod.koul@intel.com>
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/soc/intel/atom/sst/sst_stream.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/sound/soc/intel/atom/sst/sst_stream.c
+++ b/sound/soc/intel/atom/sst/sst_stream.c
@@ -108,7 +108,7 @@ int sst_alloc_stream_mrfld(struct intel_
 			str_id, pipe_id);
 	ret = sst_prepare_and_post_msg(sst_drv_ctx, task_id, IPC_CMD,
 			IPC_IA_ALLOC_STREAM_MRFLD, pipe_id, sizeof(alloc_param),
-			&alloc_param, data, true, true, false, true);
+			&alloc_param, &data, true, true, false, true);
 
 	if (ret < 0) {
 		dev_err(sst_drv_ctx->dev, "FW alloc failed ret %d\n", ret);


