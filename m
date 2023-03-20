Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 29ED76C178F
	for <lists+stable@lfdr.de>; Mon, 20 Mar 2023 16:15:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232397AbjCTPPA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Mar 2023 11:15:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47568 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232410AbjCTPOg (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Mar 2023 11:14:36 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F04DED335
        for <stable@vger.kernel.org>; Mon, 20 Mar 2023 08:09:43 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CA59F615A1
        for <stable@vger.kernel.org>; Mon, 20 Mar 2023 15:09:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D81CFC433A0;
        Mon, 20 Mar 2023 15:09:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1679324981;
        bh=dPN4NDuHUJybMvzkSTkgEA0jocHVXO9EQNgBzNl2G9w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ltqMCO/zCTazv4HFz1JDSNqREm6oNCVttfieEzWoGJ496vuDlA5q2flBHjDg+pxqt
         FUpQQoTRERDGawg3+UlKCc/NECwVQZ/yU30xZ+BY1vwQwNQYSDdqVE2YAshAoHxVbm
         l44LG/S98mXTuIkmCoREm7CuYFaTnQg8LQD9e3lw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Sven Schnelle <svens@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>
Subject: [PATCH 5.10 80/99] s390/ipl: add missing intersection check to ipl_report handling
Date:   Mon, 20 Mar 2023 15:54:58 +0100
Message-Id: <20230320145446.764185324@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230320145443.333824603@linuxfoundation.org>
References: <20230320145443.333824603@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
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
Signed-off-by: Sven Schnelle <svens@linux.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/s390/boot/ipl_report.c |    8 ++++++++
 1 file changed, 8 insertions(+)

--- a/arch/s390/boot/ipl_report.c
+++ b/arch/s390/boot/ipl_report.c
@@ -57,11 +57,19 @@ repeat:
 	if (IS_ENABLED(CONFIG_BLK_DEV_INITRD) && INITRD_START && INITRD_SIZE &&
 	    intersects(INITRD_START, INITRD_SIZE, safe_addr, size))
 		safe_addr = INITRD_START + INITRD_SIZE;
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


