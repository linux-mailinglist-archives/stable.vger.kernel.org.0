Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7F6AA498E1C
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 20:43:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354802AbiAXTjW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 14:39:22 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:60324 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345782AbiAXTc4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 14:32:56 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7DC5B61518;
        Mon, 24 Jan 2022 19:32:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 26316C340E5;
        Mon, 24 Jan 2022 19:32:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643052775;
        bh=jIFB4DyR65lRtbEr6tbrfuZymy0Zzuv0IAIULieUXJA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BM+DAkhcjtr8kFMl2r/DgPc3UkRnCtr2jYoq/tJ+MiJBKL12t0HC4sgEWHoJ3vGUl
         TrTLua4CS3JigNsbGKsuk7ZMbwYc1ia6BrScS16j/qLM1N0H77i8fpkgG45m/8YSDH
         Qyy6DgfGME3LN6wSWWHdnbftGa+y9xsVqgr71roc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Erhard Furtner <erhard_f@mailbox.org>,
        Christophe Leroy <christophe.leroy@csgroup.eu>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 137/320] powerpc/powermac: Add additional missing lockdep_register_key()
Date:   Mon, 24 Jan 2022 19:42:01 +0100
Message-Id: <20220124183958.317521976@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124183953.750177707@linuxfoundation.org>
References: <20220124183953.750177707@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christophe Leroy <christophe.leroy@csgroup.eu>

[ Upstream commit b149d5d45ac9171ed699a256f026c8ebef901112 ]

Commit df1f679d19ed ("powerpc/powermac: Add missing
lockdep_register_key()") fixed a problem that was causing a WARNING.

There are two other places in the same file with the same problem
originating from commit 9e607f72748d ("i2c_powermac: shut up lockdep
warning").

Add missing lockdep_register_key()

Fixes: 9e607f72748d ("i2c_powermac: shut up lockdep warning")
Reported-by: Erhard Furtner <erhard_f@mailbox.org>
Signed-off-by: Christophe Leroy <christophe.leroy@csgroup.eu>
Depends-on: df1f679d19ed ("powerpc/powermac: Add missing lockdep_register_key()")
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://bugzilla.kernel.org/show_bug.cgi?id=200055
Link: https://lore.kernel.org/r/2c7e421874e21b2fb87813d768cf662f630c2ad4.1638984999.git.christophe.leroy@csgroup.eu
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/platforms/powermac/low_i2c.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/powerpc/platforms/powermac/low_i2c.c b/arch/powerpc/platforms/powermac/low_i2c.c
index bf4be4b53b44d..a366233d8ac2d 100644
--- a/arch/powerpc/platforms/powermac/low_i2c.c
+++ b/arch/powerpc/platforms/powermac/low_i2c.c
@@ -811,6 +811,7 @@ static void __init pmu_i2c_probe(void)
 		bus->hostdata = bus + 1;
 		bus->xfer = pmu_i2c_xfer;
 		mutex_init(&bus->mutex);
+		lockdep_register_key(&bus->lock_key);
 		lockdep_set_class(&bus->mutex, &bus->lock_key);
 		bus->flags = pmac_i2c_multibus;
 		list_add(&bus->link, &pmac_i2c_busses);
@@ -934,6 +935,7 @@ static void __init smu_i2c_probe(void)
 		bus->hostdata = bus + 1;
 		bus->xfer = smu_i2c_xfer;
 		mutex_init(&bus->mutex);
+		lockdep_register_key(&bus->lock_key);
 		lockdep_set_class(&bus->mutex, &bus->lock_key);
 		bus->flags = 0;
 		list_add(&bus->link, &pmac_i2c_busses);
-- 
2.34.1



