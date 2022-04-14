Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 53D58500EDE
	for <lists+stable@lfdr.de>; Thu, 14 Apr 2022 15:20:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233724AbiDNNWU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 14 Apr 2022 09:22:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39030 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243993AbiDNNUt (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 14 Apr 2022 09:20:49 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7942A95A3E;
        Thu, 14 Apr 2022 06:17:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D1FD26168F;
        Thu, 14 Apr 2022 13:17:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E3EA0C385B8;
        Thu, 14 Apr 2022 13:17:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649942238;
        bh=/LOOwWxADR70oUQ6lKCBYnij1x7THp3OofmlkedM3f8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=C71H+RWfVlr/TK8wWdLvaw1sghFsL2D/J1r6gRN4RB/dXVtiEIZsN4zOcaAPK2wa1
         Tvixnew0JNXwEQRQz3PIjX/Q2A2T1FgIGZtt7LiyFiBYgui0IKnzSUc58egPJ3ae/3
         aQ8BDtIoq9Ebuk61GG0zIvpAKKzOfNgsJuk3VnIw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "Lad, Prabhakar" <prabhakar.csengg@gmail.com>,
        Johan Hovold <johan@kernel.org>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Lad@vger.kernel.org
Subject: [PATCH 4.19 062/338] media: davinci: vpif: fix unbalanced runtime PM get
Date:   Thu, 14 Apr 2022 15:09:25 +0200
Message-Id: <20220414110840.663615979@linuxfoundation.org>
X-Mailer: git-send-email 2.35.2
In-Reply-To: <20220414110838.883074566@linuxfoundation.org>
References: <20220414110838.883074566@linuxfoundation.org>
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


