Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BAB344DE72E
	for <lists+stable@lfdr.de>; Sat, 19 Mar 2022 10:13:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242554AbiCSJPI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 19 Mar 2022 05:15:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37852 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235753AbiCSJPI (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 19 Mar 2022 05:15:08 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B8748F981;
        Sat, 19 Mar 2022 02:13:48 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C344060B3A;
        Sat, 19 Mar 2022 09:13:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D6462C340ED;
        Sat, 19 Mar 2022 09:13:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1647681227;
        bh=22T0ajWd/qzOaiblrlgGkZADkyqqjG568UryfuCjbM0=;
        h=Date:From:To:Cc:Subject:From;
        b=OOgT1Tw90x9P1B75wbKJWf+RgHYzlUMULOaGa65N3uMu3Dkr8TJEXEb7tdDk7DNMS
         tU8uT1WVqaNqPtW5GngJpvz0lCXe9YIE4z5vsQ1qqA2BN+U+3pg22+E4SuusmPy21b
         aioHr3BuajUFsilIsAit3K4EAZ1lX7S8xCo5vrfE=
Date:   Sat, 19 Mar 2022 10:13:39 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Lucas Wei <lucaswei@google.com>, linux-kernel@vger.kernel.org
Subject: [PATCH v4.19.y] fs: sysfs_emit: Remove PAGE_SIZE alignment check
Message-ID: <YjWewxFJ1TmT+wFy@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Spam-Status: No, score=-8.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Lucas Wei <lucaswei@google.com>

For kernel releases older than 4.20, using the SLUB alloctor will cause
this alignment check to fail as that allocator did NOT align kmalloc
allocations on a PAGE_SIZE boundry.

Remove the check for these older kernels as it is a false-positive and
causes problems on many devices.

Signed-off-by: Lucas Wei <lucaswei@google.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

--- a/fs/sysfs/file.c
+++ b/fs/sysfs/file.c
@@ -567,8 +567,7 @@
 	va_list args;
 	int len;
 
-	if (WARN(!buf || offset_in_page(buf),
-		 "invalid sysfs_emit: buf:%p\n", buf))
+	if (WARN(!buf, "invalid sysfs_emit: buf:%p\n", buf))
 		return 0;
 
 	va_start(args, fmt);
