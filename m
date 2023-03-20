Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1016B6C193D
	for <lists+stable@lfdr.de>; Mon, 20 Mar 2023 16:32:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233075AbjCTPcB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Mar 2023 11:32:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48210 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233076AbjCTPbp (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Mar 2023 11:31:45 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 732CF2A146
        for <stable@vger.kernel.org>; Mon, 20 Mar 2023 08:24:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 87B27B80EC8
        for <stable@vger.kernel.org>; Mon, 20 Mar 2023 15:24:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E9AF9C433A4;
        Mon, 20 Mar 2023 15:24:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1679325852;
        bh=DOR/OUJcQUzxeUxsGCXdByuSyMzEfLD57lwI9SxAzQ4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=q6Kk6MTRQVOyhVgUA6WimHKGADAk8OSe0/fOXArVkwHk0Yy+qbjOo2hhg4p4uGHiL
         //xfVzeg4dJml2QG5miGx0fAfLdnrrMWFw3V7FlY40RnfDv1pmozuiQjWDnImP0jym
         BsSptRqiFTZR3SFaYig2F0LB7un5UpROixjtgl8k=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Sven Schnelle <svens@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>
Subject: [PATCH 6.1 128/198] s390/ipl: add missing intersection check to ipl_report handling
Date:   Mon, 20 Mar 2023 15:54:26 +0100
Message-Id: <20230320145512.912191701@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230320145507.420176832@linuxfoundation.org>
References: <20230320145507.420176832@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sven Schnelle <svens@linux.ibm.com>

commit a52e5cdbe8016d4e3e6322fd93d71afddb9a5af9 upstream.

The code which handles the ipl report is searching for a free location
in memory where it could copy the component and certificate entries to.
It checks for intersection between the sections required for the kernel
and the component/certificate data area, but fails to check whether
the data structures linking these data areas together intersect.

This might cause the iplreport copy code to overwrite the iplreport
itself. Fix this by adding two addtional intersection checks.

Cc: <stable@vger.kernel.org>
Fixes: 9641b8cc733f ("s390/ipl: read IPL report at early boot")
Signed-off-by: Sven Schnelle <svens@linux.ibm.com>
Reviewed-by: Vasily Gorbik <gor@linux.ibm.com>
Signed-off-by: Vasily Gorbik <gor@linux.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/s390/boot/ipl_report.c |    8 ++++++++
 1 file changed, 8 insertions(+)

--- a/arch/s390/boot/ipl_report.c
+++ b/arch/s390/boot/ipl_report.c
@@ -57,11 +57,19 @@ repeat:
 	if (IS_ENABLED(CONFIG_BLK_DEV_INITRD) && initrd_data.start && initrd_data.size &&
 	    intersects(initrd_data.start, initrd_data.size, safe_addr, size))
 		safe_addr = initrd_data.start + initrd_data.size;
+	if (intersects(safe_addr, size, (unsigned long)comps, comps->len)) {
+		safe_addr = (unsigned long)comps + comps->len;
+		goto repeat;
+	}
 	for_each_rb_entry(comp, comps)
 		if (intersects(safe_addr, size, comp->addr, comp->len)) {
 			safe_addr = comp->addr + comp->len;
 			goto repeat;
 		}
+	if (intersects(safe_addr, size, (unsigned long)certs, certs->len)) {
+		safe_addr = (unsigned long)certs + certs->len;
+		goto repeat;
+	}
 	for_each_rb_entry(cert, certs)
 		if (intersects(safe_addr, size, cert->addr, cert->len)) {
 			safe_addr = cert->addr + cert->len;


