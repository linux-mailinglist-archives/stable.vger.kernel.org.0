Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8DDBE32842A
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 17:31:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231744AbhCAQaL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 11:30:11 -0500
Received: from mail.kernel.org ([198.145.29.99]:60002 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234372AbhCAQ0g (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 11:26:36 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 37DAA64F45;
        Mon,  1 Mar 2021 16:21:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614615707;
        bh=vDTgs1r/EZY3fCr1ZtB1xpxMcUKus5eXTZGEv5Z9uYk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Oi3N7RBQVkT7BcSnVVk1BJtfBtZP0TUNMIKTFBQvs8TxnvEvJ8BYLidWS3CWBnxBy
         PtiABAR2sqPFTMHavu+TqVA5wsNauljYivKIlX4PN2yc/aPezOVwJufHJZT4NiUhbD
         ehS6z2eyS5Tnyt/mnQCHQQGJ/19z7Gi1UvY/1Oyk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Corinna Vinschen <vinschen@redhat.com>,
        Jacob Keller <jacob.e.keller@intel.com>,
        Aaron Brown <aaron.f.brown@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        Punit Agrawal <punit1.agrawal@toshiba.co.jp>
Subject: [PATCH 4.9 004/134] igb: Remove incorrect "unexpected SYS WRAP" log message
Date:   Mon,  1 Mar 2021 17:11:45 +0100
Message-Id: <20210301161013.794609666@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161013.585393984@linuxfoundation.org>
References: <20210301161013.585393984@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Corinna Vinschen <vinschen@redhat.com>

commit 2643e6e90210e16c978919617170089b7c2164f7 upstream.

TSAUXC.DisableSystime is never set, so SYSTIM runs into a SYS WRAP
every 1100 secs on 80580/i350/i354 (40 bit SYSTIM) and every 35000
secs on 80576 (45 bit SYSTIM).

This wrap event sets the TSICR.SysWrap bit unconditionally.

However, checking TSIM at interrupt time shows that this event does not
actually cause the interrupt.  Rather, it's just bycatch while the
actual interrupt is caused by, for instance, TSICR.TXTS.

The conclusion is that the SYS WRAP is actually expected, so the
"unexpected SYS WRAP" message is entirely bogus and just helps to
confuse users.  Drop it.

Signed-off-by: Corinna Vinschen <vinschen@redhat.com>
Acked-by: Jacob Keller <jacob.e.keller@intel.com>
Tested-by: Aaron Brown <aaron.f.brown@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Cc: Punit Agrawal <punit1.agrawal@toshiba.co.jp>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/intel/igb/igb_main.c |    2 --
 1 file changed, 2 deletions(-)

--- a/drivers/net/ethernet/intel/igb/igb_main.c
+++ b/drivers/net/ethernet/intel/igb/igb_main.c
@@ -5665,8 +5665,6 @@ static void igb_tsync_interrupt(struct i
 		event.type = PTP_CLOCK_PPS;
 		if (adapter->ptp_caps.pps)
 			ptp_clock_event(adapter->ptp_clock, &event);
-		else
-			dev_err(&adapter->pdev->dev, "unexpected SYS WRAP");
 		ack |= TSINTR_SYS_WRAP;
 	}
 


