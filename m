Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 063C8328758
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 18:25:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238142AbhCARXb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 12:23:31 -0500
Received: from mail.kernel.org ([198.145.29.99]:50362 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233298AbhCAROC (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 12:14:02 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id EF7D66023C;
        Mon,  1 Mar 2021 16:45:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614617129;
        bh=ylxZD6QphMt1uBf+IwusPVTKsT0T+1ZBe5Fvja7mWeI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eKo4U1SL9bKQo8S50LDJv1l2BCRFv5tU2AzFeKTtksiPLFEJSC9K8k+C1ph5jAZSC
         yiZeXVAIaTvmMBCBn70pO0KnAiP+UFxGwqK7io/z3PYxd5P7maa/4SXdkBdVG3Kq5r
         oNmR7ZKveKH0Bp9WCsmcc07dTa2nrjFAKgny/QLk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, "Pavel Machek (CIP)" <pavel@denx.de>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Subject: [PATCH 4.19 212/247] media: ipu3-cio2: Fix mbus_code processing in cio2_subdev_set_fmt()
Date:   Mon,  1 Mar 2021 17:13:52 +0100
Message-Id: <20210301161042.046969617@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161031.684018251@linuxfoundation.org>
References: <20210301161031.684018251@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pavel Machek <pavel@denx.de>

commit 334de4b45892f7e67074e1b1b2ac36fd3e091118 upstream.

Loop was useless as it would always exit on the first iteration. Fix
it with right condition.

Signed-off-by: Pavel Machek (CIP) <pavel@denx.de>
Fixes: a86cf9b29e8b ("media: ipu3-cio2: Validate mbus format in setting subdev format")
Tested-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: stable@vger.kernel.org # v4.16 and up
Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/pci/intel/ipu3/ipu3-cio2.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/media/pci/intel/ipu3/ipu3-cio2.c
+++ b/drivers/media/pci/intel/ipu3/ipu3-cio2.c
@@ -1290,7 +1290,7 @@ static int cio2_subdev_set_fmt(struct v4
 	fmt->format.code = formats[0].mbus_code;
 
 	for (i = 0; i < ARRAY_SIZE(formats); i++) {
-		if (formats[i].mbus_code == fmt->format.code) {
+		if (formats[i].mbus_code == mbus_code) {
 			fmt->format.code = mbus_code;
 			break;
 		}


