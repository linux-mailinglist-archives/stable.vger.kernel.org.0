Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3500B5B73BF
	for <lists+stable@lfdr.de>; Tue, 13 Sep 2022 17:13:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235190AbiIMPJc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 13 Sep 2022 11:09:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55036 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235603AbiIMPIu (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 13 Sep 2022 11:08:50 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED4792C663;
        Tue, 13 Sep 2022 07:31:24 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D8CDEB80EFA;
        Tue, 13 Sep 2022 14:31:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 44CEDC433C1;
        Tue, 13 Sep 2022 14:31:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1663079481;
        bh=g4OSy4eiWzd4GXoIulDPPUyvFbwo6gtuf8PChh14Lrc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CjfGvGPeOJdJSQQ8iefAka/A6wmTLjNItdP95Z/vd5dqeOGNhYMTVoplUEAJzGF+B
         +OtAKBMBHfGsSKdtbWAV/Q/NntCY1TjamMwV6s8kMWAI7WEpinwIXbBKl3puDVgIX3
         ul3PbdnYaHUKJw00u3dsPGA8iX0XBUd+EGYkus/M=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Alan Stern <stern@rowland.harvard.edu>,
        Krishna Kurapati <quic_kriskura@quicinc.com>
Subject: [PATCH 4.19 44/79] usb: gadget: mass_storage: Fix cdrom data transfers on MAC-OS
Date:   Tue, 13 Sep 2022 16:07:02 +0200
Message-Id: <20220913140351.046519972@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220913140348.835121645@linuxfoundation.org>
References: <20220913140348.835121645@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Krishna Kurapati <quic_kriskura@quicinc.com>

commit 9d4dc16ec71bd6368548e9743223e449b4377fc7 upstream.

During cdrom emulation, the response to read_toc command must contain
the cdrom address as the number of sectors (2048 byte sized blocks)
represented either as an absolute value (when MSF bit is '0') or in
terms of PMin/PSec/PFrame (when MSF bit is set to '1'). Incase of
cdrom, the fsg_lun_open call sets the sector size to 2048 bytes.

When MAC OS sends a read_toc request with MSF set to '1', the
store_cdrom_address assumes that the address being provided is the
LUN size represented in 512 byte sized blocks instead of 2048. It
tries to modify the address further to convert it to 2048 byte sized
blocks and store it in MSF format. This results in data transfer
failures as the cdrom address being provided in the read_toc response
is incorrect.

Fixes: 3f565a363cee ("usb: gadget: storage: adapt logic block size to bound block devices")
Cc: stable@vger.kernel.org
Acked-by: Alan Stern <stern@rowland.harvard.edu>
Signed-off-by: Krishna Kurapati <quic_kriskura@quicinc.com>
Link: https://lore.kernel.org/r/1661570110-19127-1-git-send-email-quic_kriskura@quicinc.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/gadget/function/storage_common.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/drivers/usb/gadget/function/storage_common.c
+++ b/drivers/usb/gadget/function/storage_common.c
@@ -294,8 +294,10 @@ EXPORT_SYMBOL_GPL(fsg_lun_fsync_sub);
 void store_cdrom_address(u8 *dest, int msf, u32 addr)
 {
 	if (msf) {
-		/* Convert to Minutes-Seconds-Frames */
-		addr >>= 2;		/* Convert to 2048-byte frames */
+		/*
+		 * Convert to Minutes-Seconds-Frames.
+		 * Sector size is already set to 2048 bytes.
+		 */
 		addr += 2*75;		/* Lead-in occupies 2 seconds */
 		dest[3] = addr % 75;	/* Frames */
 		addr /= 75;


