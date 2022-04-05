Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 66D3D4F2557
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 09:47:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232245AbiDEHtR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 03:49:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52976 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233668AbiDEHsZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 03:48:25 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D079C4;
        Tue,  5 Apr 2022 00:46:28 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id BFE9EB81B98;
        Tue,  5 Apr 2022 07:46:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1186DC340EE;
        Tue,  5 Apr 2022 07:46:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649144785;
        bh=9hCBRRhKdCVoieEBBCzN/gKOJEsz/ukjx7l7GEHMlns=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kuULiJawDXFHSHsxcOmldLrVGhlqdhokUFxnqPkKTWgB/eD2JE7m4qn8xg5owFIg3
         rArj2VGuj2XL8e/hnkxO6YV364U7IaJuxzy649K966jOHCEtNs8Svt3L78pF91XhZw
         rQO7jPJg4ORTJJYEPu7LHCefKbh1OZrvS1GNLzvY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ameer Hamza <amhamza.mgc@gmail.com>,
        Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>,
        Stanimir Varbanov <stanimir.varbanov@linaro.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Subject: [PATCH 5.17 0169/1126] media: venus: vdec: fixed possible memory leak issue
Date:   Tue,  5 Apr 2022 09:15:16 +0200
Message-Id: <20220405070412.559862423@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070407.513532867@linuxfoundation.org>
References: <20220405070407.513532867@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ameer Hamza <amhamza.mgc@gmail.com>

commit 8403fdd775858a7bf04868d43daea0acbe49ddfc upstream.

The venus_helper_alloc_dpb_bufs() implementation allows an early return
on an error path when checking the id from ida_alloc_min() which would
not release the earlier buffer allocation.

Move the direct kfree() from the error checking of dma_alloc_attrs() to
the common fail path to ensure that allocations are released on all
error paths in this function.

Addresses-Coverity: 1494120 ("Resource leak")

cc: stable@vger.kernel.org # 5.16+
Fixes: 40d87aafee29 ("media: venus: vdec: decoded picture buffer handling during reconfig sequence")
Signed-off-by: Ameer Hamza <amhamza.mgc@gmail.com>
Reviewed-by: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
Signed-off-by: Stanimir Varbanov <stanimir.varbanov@linaro.org>
Signed-off-by: Mauro Carvalho Chehab <mchehab@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/platform/qcom/venus/helpers.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/media/platform/qcom/venus/helpers.c
+++ b/drivers/media/platform/qcom/venus/helpers.c
@@ -189,7 +189,6 @@ int venus_helper_alloc_dpb_bufs(struct v
 		buf->va = dma_alloc_attrs(dev, buf->size, &buf->da, GFP_KERNEL,
 					  buf->attrs);
 		if (!buf->va) {
-			kfree(buf);
 			ret = -ENOMEM;
 			goto fail;
 		}
@@ -209,6 +208,7 @@ int venus_helper_alloc_dpb_bufs(struct v
 	return 0;
 
 fail:
+	kfree(buf);
 	venus_helper_free_dpb_bufs(inst);
 	return ret;
 }


