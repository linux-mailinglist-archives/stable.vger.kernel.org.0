Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 837414F32A5
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 14:59:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345213AbiDEKku (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 06:40:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50268 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244331AbiDEJlO (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 05:41:14 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AEF15BB0B3;
        Tue,  5 Apr 2022 02:26:10 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D00F061680;
        Tue,  5 Apr 2022 09:26:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC31AC385A3;
        Tue,  5 Apr 2022 09:26:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649150769;
        bh=/LOOwWxADR70oUQ6lKCBYnij1x7THp3OofmlkedM3f8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SWSbRRD7zRFAnI7gvnS+CrCo2K+Sxfhzt2Oj8+WkvHHViSNA5+6x53ndXN/cRu0F0
         I0qVeMZx32j0yVHy4B1oS1PnIkgRsMCS5Y7cG1/nDWA+NBmqhv4kCc0pLMz8XUMcz1
         qA7dR3fjKRd3uQe7MJj8qjRanwsamo+ZOVowZERQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "Lad, Prabhakar" <prabhakar.csengg@gmail.com>,
        Johan Hovold <johan@kernel.org>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Lad@vger.kernel.org
Subject: [PATCH 5.15 167/913] media: davinci: vpif: fix unbalanced runtime PM get
Date:   Tue,  5 Apr 2022 09:20:29 +0200
Message-Id: <20220405070344.853322187@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070339.801210740@linuxfoundation.org>
References: <20220405070339.801210740@linuxfoundation.org>
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

From: Johan Hovold <johan@kernel.org>

commit 4a321de239213300a714fa0353a5f1272d381a44 upstream.

Make sure to balance the runtime PM usage counter on driver unbind.

Fixes: 407ccc65bfd2 ("[media] davinci: vpif: add pm_runtime support")
Cc: stable@vger.kernel.org      # 3.9
Cc: Lad, Prabhakar <prabhakar.csengg@gmail.com>
Signed-off-by: Johan Hovold <johan@kernel.org>
Reviewed-by: Lad Prabhakar <prabhakar.csengg@gmail.com>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Mauro Carvalho Chehab <mchehab@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/platform/davinci/vpif.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/media/platform/davinci/vpif.c
+++ b/drivers/media/platform/davinci/vpif.c
@@ -496,6 +496,7 @@ static int vpif_probe(struct platform_de
 
 static int vpif_remove(struct platform_device *pdev)
 {
+	pm_runtime_put(&pdev->dev);
 	pm_runtime_disable(&pdev->dev);
 	return 0;
 }


