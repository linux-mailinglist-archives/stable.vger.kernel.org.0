Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C3CCD44C810
	for <lists+stable@lfdr.de>; Wed, 10 Nov 2021 19:57:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232771AbhKJS6u (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 10 Nov 2021 13:58:50 -0500
Received: from mail.kernel.org ([198.145.29.99]:52542 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233970AbhKJS4c (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 10 Nov 2021 13:56:32 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id E58F461052;
        Wed, 10 Nov 2021 18:49:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1636570194;
        bh=7ELfN9JM7gUP38esY+laJAI+JHO6KXQwvUnsXFCAlrU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=O5N3U+FA3Q1lKxb2YKZZG5/224HC4dt5qaw8kA4qI3faYxzSw9ncx9zWbDqStTU07
         nZ80sxarPQwjVkgxEYB+1W32r3ygMfq6SyU18zoqJCx60qTn0Q4n1I+j2QrVOjQfLX
         v/fC6EQMX+90iHyIzOdtDXcJGmLQhemaYmhfi+Qc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Subject: [PATCH 5.14 23/24] media: staging/intel-ipu3: css: Fix wrong size comparison imgu_css_fw_init
Date:   Wed, 10 Nov 2021 19:44:15 +0100
Message-Id: <20211110182004.077953974@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211110182003.342919058@linuxfoundation.org>
References: <20211110182003.342919058@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Gustavo A. R. Silva <gustavoars@kernel.org>

commit a44f9d6f9dc1fb314a3f1ed2dcd4fbbcc3d9f892 upstream.

There is a wrong comparison of the total size of the loaded firmware
css->fw->size with the size of a pointer to struct imgu_fw_header.

Turn binary_header into a flexible-array member[1][2], use the
struct_size() helper and fix the wrong size comparison. Notice
that the loaded firmware needs to contain at least one 'struct
imgu_fw_info' item in the binary_header[] array.

It's also worth mentioning that

	"css->fw->size < struct_size(css->fwp, binary_header, 1)"

with binary_header declared as a flexible-array member is equivalent
to

	"css->fw->size < sizeof(struct imgu_fw_header)"

with binary_header declared as a one-element array (as in the original
code).

The replacement of the one-element array with a flexible-array member
also helps with the ongoing efforts to globally enable -Warray-bounds
and get us closer to being able to tighten the FORTIFY_SOURCE routines
on memcpy().

[1] https://en.wikipedia.org/wiki/Flexible_array_member
[2] https://www.kernel.org/doc/html/v5.10/process/deprecated.html#zero-length-and-one-element-arrays

Link: https://github.com/KSPP/linux/issues/79
Link: https://github.com/KSPP/linux/issues/109

Fixes: 09d290f0ba21 ("media: staging/intel-ipu3: css: Add support for firmware management")
Cc: stable@vger.kernel.org
Signed-off-by: Gustavo A. R. Silva <gustavoars@kernel.org>
Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/staging/media/ipu3/ipu3-css-fw.c |    7 +++----
 drivers/staging/media/ipu3/ipu3-css-fw.h |    2 +-
 2 files changed, 4 insertions(+), 5 deletions(-)

--- a/drivers/staging/media/ipu3/ipu3-css-fw.c
+++ b/drivers/staging/media/ipu3/ipu3-css-fw.c
@@ -124,12 +124,11 @@ int imgu_css_fw_init(struct imgu_css *cs
 	/* Check and display fw header info */
 
 	css->fwp = (struct imgu_fw_header *)css->fw->data;
-	if (css->fw->size < sizeof(struct imgu_fw_header *) ||
+	if (css->fw->size < struct_size(css->fwp, binary_header, 1) ||
 	    css->fwp->file_header.h_size != sizeof(struct imgu_fw_bi_file_h))
 		goto bad_fw;
-	if (sizeof(struct imgu_fw_bi_file_h) +
-	    css->fwp->file_header.binary_nr * sizeof(struct imgu_fw_info) >
-	    css->fw->size)
+	if (struct_size(css->fwp, binary_header,
+			css->fwp->file_header.binary_nr) > css->fw->size)
 		goto bad_fw;
 
 	dev_info(dev, "loaded firmware version %.64s, %u binaries, %zu bytes\n",
--- a/drivers/staging/media/ipu3/ipu3-css-fw.h
+++ b/drivers/staging/media/ipu3/ipu3-css-fw.h
@@ -171,7 +171,7 @@ struct imgu_fw_bi_file_h {
 
 struct imgu_fw_header {
 	struct imgu_fw_bi_file_h file_header;
-	struct imgu_fw_info binary_header[1];	/* binary_nr items */
+	struct imgu_fw_info binary_header[];	/* binary_nr items */
 };
 
 /******************* Firmware functions *******************/


