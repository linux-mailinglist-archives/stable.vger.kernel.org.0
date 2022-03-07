Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7968A4CF765
	for <lists+stable@lfdr.de>; Mon,  7 Mar 2022 10:45:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238062AbiCGJp4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Mar 2022 04:45:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51422 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240698AbiCGJl2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Mar 2022 04:41:28 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 78338FD2F;
        Mon,  7 Mar 2022 01:38:06 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5CCE4B810D2;
        Mon,  7 Mar 2022 09:37:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C5542C340E9;
        Mon,  7 Mar 2022 09:37:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1646645868;
        bh=VbmKCL72Oen/J1WzvyZ7/8kn5y0mhpkYsLrA1c3G/+4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eYwOu194p0/yDL9w2DOtG9/zMYF2gujpjzcY4U3whg0kyvgPtuUtLTeYWENba7r71
         3CmdCDbjR38IUK3rehHxno9Tqkvow79w3G7s4cVzaH1ui8EpepSUzGSPeIf2fjpH5h
         b+2/kZ3m5LtMVURlW8DFqD+iOWiEi3sU0jnPaHbQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Boris Brezillon <bbrezillon@kernel.org>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Jamie Iles <quic_jiles@quicinc.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 061/262] i3c: fix incorrect address slot lookup on 64-bit
Date:   Mon,  7 Mar 2022 10:16:45 +0100
Message-Id: <20220307091704.230344957@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220307091702.378509770@linuxfoundation.org>
References: <20220307091702.378509770@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jamie Iles <quic_jiles@quicinc.com>

[ Upstream commit f18f98110f2b179792cb70d85cba697320a3790f ]

The address slot bitmap is an array of unsigned long's which are the
same size as an int on 32-bit platforms but not 64-bit.  Loading the
bitmap into an int could result in the incorrect status being returned
for a slot and slots being reported as the wrong status.

Fixes: 3a379bbcea0a ("i3c: Add core I3C infrastructure")
Cc: Boris Brezillon <bbrezillon@kernel.org>
Cc: Alexandre Belloni <alexandre.belloni@bootlin.com>
Signed-off-by: Jamie Iles <quic_jiles@quicinc.com>
Signed-off-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
Link: https://lore.kernel.org/r/20210922165600.179394-1-quic_jiles@quicinc.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/i3c/master.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/i3c/master.c b/drivers/i3c/master.c
index c3b4c677b4429..dfe18dcd008d4 100644
--- a/drivers/i3c/master.c
+++ b/drivers/i3c/master.c
@@ -343,7 +343,8 @@ struct bus_type i3c_bus_type = {
 static enum i3c_addr_slot_status
 i3c_bus_get_addr_slot_status(struct i3c_bus *bus, u16 addr)
 {
-	int status, bitpos = addr * 2;
+	unsigned long status;
+	int bitpos = addr * 2;
 
 	if (addr > I2C_MAX_ADDR)
 		return I3C_ADDR_SLOT_RSVD;
-- 
2.34.1



