Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 79CD93136E0
	for <lists+stable@lfdr.de>; Mon,  8 Feb 2021 16:17:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232921AbhBHPRB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Feb 2021 10:17:01 -0500
Received: from mail.kernel.org ([198.145.29.99]:56630 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232762AbhBHPMa (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Feb 2021 10:12:30 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1FED064EF6;
        Mon,  8 Feb 2021 15:09:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1612796949;
        bh=W/2o5MaR2BjFR8GMc42gVrAmNAJbB88oaycMtQ+zfgc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=K8O9YBrHSIsAz+XI1xKlurp4z6QYVTbIvvJgCmu7SCWabnsLJ1lP649QweyQfKRSP
         4BuCXz0nXXhy2Qtg3FuJwfepgd+Ma3+JqV4lbvXIFCmXpZ57+ai7es8Ek8e31yPabC
         C0CsuNfi95tNYmlOvoCBALGVAgswyop3VYfp0/eU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, DENG Qingfang <dqfext@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 4.19 38/38] net: dsa: mv88e6xxx: override existent unicast portvec in port_fdb_add
Date:   Mon,  8 Feb 2021 16:01:25 +0100
Message-Id: <20210208145807.694600084@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210208145806.141056364@linuxfoundation.org>
References: <20210208145806.141056364@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: DENG Qingfang <dqfext@gmail.com>

commit f72f2fb8fb6be095b98af5d740ac50cffd0b0cae upstream.

Having multiple destination ports for a unicast address does not make
sense.
Make port_db_load_purge override existent unicast portvec instead of
adding a new port bit.

Fixes: 884729399260 ("net: dsa: mv88e6xxx: handle multiple ports in ATU")
Signed-off-by: DENG Qingfang <dqfext@gmail.com>
Reviewed-by: Vladimir Oltean <olteanv@gmail.com>
Link: https://lore.kernel.org/r/20210130134334.10243-1-dqfext@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/dsa/mv88e6xxx/chip.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- a/drivers/net/dsa/mv88e6xxx/chip.c
+++ b/drivers/net/dsa/mv88e6xxx/chip.c
@@ -1658,7 +1658,11 @@ static int mv88e6xxx_port_db_load_purge(
 		if (!entry.portvec)
 			entry.state = MV88E6XXX_G1_ATU_DATA_STATE_UNUSED;
 	} else {
-		entry.portvec |= BIT(port);
+		if (state == MV88E6XXX_G1_ATU_DATA_STATE_UC_STATIC)
+			entry.portvec = BIT(port);
+		else
+			entry.portvec |= BIT(port);
+
 		entry.state = state;
 	}
 


