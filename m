Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 61EB3614944
	for <lists+stable@lfdr.de>; Tue,  1 Nov 2022 12:35:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230434AbiKALfj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Nov 2022 07:35:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48286 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230439AbiKALfK (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 1 Nov 2022 07:35:10 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E85AF6448;
        Tue,  1 Nov 2022 04:31:09 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D488A615EA;
        Tue,  1 Nov 2022 11:30:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3ACB6C433C1;
        Tue,  1 Nov 2022 11:30:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1667302232;
        bh=iMtcZ2hgd/8o3eZRyC05fwrDGSMl1QLWd9ncN2TxP78=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NrQBDsELl3mVQ5SpMh/ctW05BsDTaGyXhkp8RsrNHnKWyh/mOhrO0NIzE+Bn+zAg6
         nT6/GTHa5rqliWOCkwDz1qhPx9YzHlKMs9kgfWd7C+du+E0ptcumHX+Z4lQ8hCpsVj
         k8g0Vrgsaw/1AJQl10ILLhhbIbNUj34r0P+EMvI0GsJOJ/JBepfgueTvJ3gGjjLpxT
         dcaewN7k/SsvKQHhV0bs/GBEYbv7hVlTQWXEcEPj9ufY+rCB5lzxyDDHw6CK2EW7kZ
         T1uARhO/fX29bRlC+PnfaJ/slXVrxKQM8fcOUKiRuGd/KovFA325kYnmJU8snhImvI
         OTzvsvB5NQ7uQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Hans de Goede <hdegoede@redhat.com>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Sasha Levin <sashal@kernel.org>, gregkh@linuxfoundation.org,
        andriy.shevchenko@linux.intel.com, kitakar@gmail.com,
        linux-media@vger.kernel.org, linux-staging@lists.linux.dev
Subject: [PATCH AUTOSEL 5.10 07/14] media: atomisp: Ensure that USERPTR pointers are page aligned
Date:   Tue,  1 Nov 2022 07:30:03 -0400
Message-Id: <20221101113012.800271-7-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221101113012.800271-1-sashal@kernel.org>
References: <20221101113012.800271-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hans de Goede <hdegoede@redhat.com>

[ Upstream commit 6e6c4ae0f0ba295dbf6cbd48d93bec169d6ce431 ]

The atomisp code needs USERPTR pointers to be page aligned,
otherwise bad things (scribbling over other parts of the
process' RAM) happen.

Add a check to ensure this and exit VIDIOC_QBUF calls with
unaligned pointers with -EINVAL.

Reviewed-by: Andy Shevchenko <andy.shevchenko@gmail.com>
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/staging/media/atomisp/pci/atomisp_ioctl.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/staging/media/atomisp/pci/atomisp_ioctl.c b/drivers/staging/media/atomisp/pci/atomisp_ioctl.c
index 8a0648fd7c81..317db11703e6 100644
--- a/drivers/staging/media/atomisp/pci/atomisp_ioctl.c
+++ b/drivers/staging/media/atomisp/pci/atomisp_ioctl.c
@@ -1290,6 +1290,12 @@ static int atomisp_qbuf(struct file *file, void *fh, struct v4l2_buffer *buf)
 	 * address and reprograme out page table properly
 	 */
 	if (buf->memory == V4L2_MEMORY_USERPTR) {
+		if (offset_in_page(buf->m.userptr)) {
+			dev_err(isp->dev, "Error userptr is not page aligned.\n");
+			ret = -EINVAL;
+			goto error;
+		}
+
 		vb = pipe->capq.bufs[buf->index];
 		vm_mem = vb->priv;
 		if (!vm_mem) {
-- 
2.35.1

