Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 704BD370633
	for <lists+stable@lfdr.de>; Sat,  1 May 2021 09:28:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231236AbhEAH3i (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 1 May 2021 03:29:38 -0400
Received: from fgw20-4.mail.saunalahti.fi ([62.142.5.107]:22992 "EHLO
        fgw20-4.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229510AbhEAH3h (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 1 May 2021 03:29:37 -0400
X-Greylist: delayed 963 seconds by postgrey-1.27 at vger.kernel.org; Sat, 01 May 2021 03:29:37 EDT
Received: from toshiba (85-156-79-75.elisa-laajakaista.fi [85.156.79.75])
        by fgw20.mail.saunalahti.fi (Halon) with ESMTP
        id 9f594604-aa4c-11eb-ba24-005056bd6ce9;
        Sat, 01 May 2021 10:12:43 +0300 (EEST)
Message-ID: <608CFF6A.4BC054A3@users.sourceforge.net>
Date:   Sat, 01 May 2021 10:12:42 +0300
From:   Jari Ruusu <jariruusu@users.sourceforge.net>
MIME-Version: 1.0
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Jiri Kosina <jkosina@suse.cz>,
        Kalle Valo <kvalo@codeaurora.org>
Subject: Re: [PATCH 5.10 1/2] iwlwifi: Fix softirq/hardirq disabling in 
 iwl_pcie_gen2_enqueue_hcmd()
References: <20210430141910.473289618@linuxfoundation.org> <20210430141910.521897363@linuxfoundation.org>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Greg Kroah-Hartman wrote:
> From: Jiri Kosina <jkosina@suse.cz>
> 
> commit e7020bb068d8be50a92f48e36b236a1a1ef9282e upstream.
> 
> Analogically to what we did in 2800aadc18a6 ("iwlwifi: Fix softirq/hardirq
> disabling in iwl_pcie_enqueue_hcmd()"), we must apply the same fix to
> iwl_pcie_gen2_enqueue_hcmd(), as it's being called from exactly the same
> contexts.

Greg,
This patch and above mentioned earlier patch
"iwlwifi: Fix softirq/hardirq disabling in iwl_pcie_enqueue_hcmd()",
upstream commit 2800aadc18a64c96b051bcb7da8a7df7d505db3f, both need
to be backported to older kernels too.

I see that there are trivial context rejects if/when you attempt to
apply those patches to older kernels. Those trivial context rejects
should not prevent backporting them. Maybe run both patches through sed?

sed -e s/iwl_txq_space/iwl_queue_space/ -e s/iwl_txq_get_/iwl_pcie_get_/

My ability test in-tree iwlwifi is limited. I compile out-of-tree
iwlwifi source, and testing that is limited to pinging mobile-wifi
router that does not have SIM-card.

-- 
Jari Ruusu  4096R/8132F189 12D6 4C3A DCDA 0AA4 27BD  ACDF F073 3C80 8132 F189
