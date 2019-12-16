Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2A9371214ED
	for <lists+stable@lfdr.de>; Mon, 16 Dec 2019 19:16:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731542AbfLPSQ3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Dec 2019 13:16:29 -0500
Received: from mail.kernel.org ([198.145.29.99]:39032 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731535AbfLPSQ3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 16 Dec 2019 13:16:29 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 35BA8207FF;
        Mon, 16 Dec 2019 18:16:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576520188;
        bh=o5DgSwACQn3g13+wAyuxHX+E7BQK/uk71Z4ObQXjzYg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JZKoJYzFyKGvWckqmZcrAm/p78wFbI7zTGEVb5qVjz8jHp+r6UphP0P5LdwSE5d+P
         /C9hSVobbxbJFxxWVBD0AvKjYXrwjmo1rjLNzqI/CpruFGS77yYONRrP/7NS2OmrNp
         fDy5WSjXT4EdBQql//ZQcEVC0C7Ix9qrsfF/4Pdg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Meng Li <Meng.Li@windriver.com>,
        Thor Thayer <thor.thayer@linux.intel.com>,
        Borislav Petkov <bp@suse.de>,
        James Morse <james.morse@arm.com>,
        linux-edac <linux-edac@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Robert Richter <rrichter@marvell.com>,
        Tony Luck <tony.luck@intel.com>
Subject: [PATCH 5.4 053/177] EDAC/altera: Use fast register IO for S10 IRQs
Date:   Mon, 16 Dec 2019 18:48:29 +0100
Message-Id: <20191216174830.591722289@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191216174811.158424118@linuxfoundation.org>
References: <20191216174811.158424118@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Meng Li <Meng.Li@windriver.com>

commit 56d9e7bd3fa0f105b6670021d167744bc50ae4fe upstream.

When an IRQ occurs, regmap_{read,write,...}() is invoked in atomic
context. Regmap must indicate register IO is fast so that a spinlock is
used instead of a mutex to avoid sleeping in atomic context:

  lock_acquire
  __mutex_lock
  mutex_lock_nested
  regmap_lock_mutex
  regmap_write
  a10_eccmgr_irq_unmask
  unmask_irq.part.0
  irq_enable
  __irq_startup
  irq_startup
  __setup_irq
  request_threaded_irq
  devm_request_threaded_irq
  altr_sdram_probe

Mark it so.

 [ bp: Massage. ]

Fixes: 3dab6bd52687 ("EDAC, altera: Add support for Stratix10 SDRAM EDAC")
Reported-by: Meng Li <Meng.Li@windriver.com>
Signed-off-by: Meng Li <Meng.Li@windriver.com>
Signed-off-by: Thor Thayer <thor.thayer@linux.intel.com>
Signed-off-by: Borislav Petkov <bp@suse.de>
Cc: James Morse <james.morse@arm.com>
Cc: linux-edac <linux-edac@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: Robert Richter <rrichter@marvell.com>
Cc: stable <stable@vger.kernel.org>
Cc: Tony Luck <tony.luck@intel.com>
Link: https://lkml.kernel.org/r/1574361048-17572-2-git-send-email-thor.thayer@linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/edac/altera_edac.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/edac/altera_edac.c
+++ b/drivers/edac/altera_edac.c
@@ -560,6 +560,7 @@ static const struct regmap_config s10_sd
 	.reg_write = s10_protected_reg_write,
 	.use_single_read = true,
 	.use_single_write = true,
+	.fast_io = true,
 };
 
 /************** </Stratix10 EDAC Memory Controller Functions> ***********/


