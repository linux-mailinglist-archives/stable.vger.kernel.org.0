Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1D0026AF5CD
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 20:36:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234018AbjCGTgt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 14:36:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45532 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234046AbjCGTgQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 14:36:16 -0500
Received: from relay7-d.mail.gandi.net (relay7-d.mail.gandi.net [217.70.183.200])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9139577C83;
        Tue,  7 Mar 2023 11:23:19 -0800 (PST)
Received: (Authenticated sender: miquel.raynal@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id 4F39020002;
        Tue,  7 Mar 2023 19:23:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1678216998;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=QJJCv8W0ACpAYFHCo0idxfjeMs3ZN9nrZwLGXiNnvZY=;
        b=Wb/tQICvkHw95iQ58tZ4ewXTAX7wiGd3KCgGHicSyLRNwqYSrkuQbG6beKrj+Nz5iTLLI7
        cB2/vDImq0IxcMJDv9FXRTG0Kd3UBs6PwDuMual1f52BRz5xIYCDQwQ39uke8+SSCfJueD
        EkJVb8KpXUFVvjTe2ARcN2He1zSCZRWYZ5y+sbpRQaWMyYcgfzYxNWl1RMM3Jn18dl6Jxl
        kHz48Lb79OzaFUDAdQqv//SH0jxHn+nq4jIytwnksdl/MFEeCdzylHWXDos6In+jXd48w3
        Dyz/bwNqoL6ZsjsCky9/I5lj8s0vJxPMRcn7ECMjIqZR4ScuWsprczb3XWeyyQ==
From:   Miquel Raynal <miquel.raynal@bootlin.com>
To:     Michael Walle <michael@walle.cc>,
        Miquel Raynal <miquel.raynal@bootlin.com>,
        Richard Weinberger <richard@nod.at>,
        Vignesh Raghavendra <vigneshr@ti.com>
Cc:     linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH 3/4] mtd: core: fix error path for nvmem provider
Date:   Tue,  7 Mar 2023 20:23:15 +0100
Message-Id: <20230307192315.353603-1-miquel.raynal@bootlin.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230306125805.678668-3-michael@walle.cc>
References: 
MIME-Version: 1.0
X-linux-mtd-patch-notification: thanks
X-linux-mtd-patch-commit: b'43782116d148e40caa0e04f1404db966347d4420'
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 2023-03-06 at 12:58:04 UTC, Michael Walle wrote:
> If mtd_otp_nvmem_add() fails, the partitions won't be removed
> because there is simply no call to del_mtd_partitions().
> Unfortunately, add_mtd_partitions() will print all partitions to
> the kernel console. If mtd_otp_nvmem_add() returns -EPROBE_DEFER
> this would print the partitions multiple times to the kernel
> console. Instead move mtd_otp_nvmem_add() to the beginning of the
> function.
> 
> Fixes: 4b361cfa8624 ("mtd: core: add OTP nvmem provider support")
> Cc: stable@vger.kernel.org
> Signed-off-by: Michael Walle <michael@walle.cc>

Applied to https://git.kernel.org/pub/scm/linux/kernel/git/mtd/linux.git mtd/next, thanks.

Miquel
