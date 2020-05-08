Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 46B881CAE4C
	for <lists+stable@lfdr.de>; Fri,  8 May 2020 15:10:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729780AbgEHNIi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 May 2020 09:08:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:53104 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729269AbgEHNF2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 8 May 2020 09:05:28 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EC3B9249EA;
        Fri,  8 May 2020 13:05:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588943128;
        bh=r7PKOH3bBleIWEyK3BOCDG/z9KsJ9MtNZcsioTG9Qp4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=juVFALqDYnsyEZ7offl6bx4BpFVLKxbD5W7+iixXyVcyAlw1MYncutM5sKwwj+5GK
         sU911r66JA9/DeFvbA3civihsKBtI69a5RJMQjmdUAgtDBbXbiOLrbS2wNJlWh5K+N
         2JXo21K5C7+wJW5KzFhbpw2wh/v5XR3ovC+EDrxk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        "Lad, Prabhakar" <prabhakar.csengg@gmail.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Subject: [PATCH 4.4 171/312] [media] am437x-vpfe: fix an uninitialized variable bug
Date:   Fri,  8 May 2020 14:32:42 +0200
Message-Id: <20200508123136.527536560@linuxfoundation.org>
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

commit e4bccada44c177cde31b9a236b7dfd7f76d403ed upstream.

If we are doing V4L2_FIELD_NONE then "ret" is used uninitialized.

Fixes: 417d2e507edc ('[media] media: platform: add VPFE capture driver support for AM437X')

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Acked-by: Lad, Prabhakar <prabhakar.csengg@gmail.com>
Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/media/platform/am437x/am437x-vpfe.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/media/platform/am437x/am437x-vpfe.c
+++ b/drivers/media/platform/am437x/am437x-vpfe.c
@@ -1047,7 +1047,7 @@ static int vpfe_get_ccdc_image_format(st
 static int vpfe_config_ccdc_image_format(struct vpfe_device *vpfe)
 {
 	enum ccdc_frmfmt frm_fmt = CCDC_FRMFMT_INTERLACED;
-	int ret;
+	int ret = 0;
 
 	vpfe_dbg(2, vpfe, "vpfe_config_ccdc_image_format\n");
 


