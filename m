Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4D3A73A6174
	for <lists+stable@lfdr.de>; Mon, 14 Jun 2021 12:45:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234036AbhFNKrw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Jun 2021 06:47:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:51420 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233638AbhFNKpv (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 14 Jun 2021 06:45:51 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5C2406128A;
        Mon, 14 Jun 2021 10:36:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1623666993;
        bh=4b+kN5kgYUJozpZ0feh5k1wvn1s8BWKCOUy7nfMwHoA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=C5WolUT63Qk8UZIktDP1GHzkYn6Sc/1yfvDuzCZ5+Bi/+G8Lq0CN/5gSiKHGReiJX
         Q0dXjUr5Zj4hOZb3kz0FH+xjEAKR61gb1aTGvKr+jbGUbX7aLcseayEFljipHCMMhD
         wngbyHyUbasUhrTYzxlJqSa5X92r8N/A5/NYlE40=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Marian-Cristian Rotariu <marian.c.rotariu@gmail.com>
Subject: [PATCH 4.19 39/67] usb: dwc3: ep0: fix NULL pointer exception
Date:   Mon, 14 Jun 2021 12:27:22 +0200
Message-Id: <20210614102645.104994604@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210614102643.797691914@linuxfoundation.org>
References: <20210614102643.797691914@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Marian-Cristian Rotariu <marian.c.rotariu@gmail.com>

commit d00889080ab60051627dab1d85831cd9db750e2a upstream.

There is no validation of the index from dwc3_wIndex_to_dep() and we might
be referring a non-existing ep and trigger a NULL pointer exception. In
certain configurations we might use fewer eps and the index might wrongly
indicate a larger ep index than existing.

By adding this validation from the patch we can actually report a wrong
index back to the caller.

In our usecase we are using a composite device on an older kernel, but
upstream might use this fix also. Unfortunately, I cannot describe the
hardware for others to reproduce the issue as it is a proprietary
implementation.

[   82.958261] Unable to handle kernel NULL pointer dereference at virtual address 00000000000000a4
[   82.966891] Mem abort info:
[   82.969663]   ESR = 0x96000006
[   82.972703]   Exception class = DABT (current EL), IL = 32 bits
[   82.978603]   SET = 0, FnV = 0
[   82.981642]   EA = 0, S1PTW = 0
[   82.984765] Data abort info:
[   82.987631]   ISV = 0, ISS = 0x00000006
[   82.991449]   CM = 0, WnR = 0
[   82.994409] user pgtable: 4k pages, 39-bit VAs, pgdp = 00000000c6210ccc
[   83.000999] [00000000000000a4] pgd=0000000053aa5003, pud=0000000053aa5003, pmd=0000000000000000
[   83.009685] Internal error: Oops: 96000006 [#1] PREEMPT SMP
[   83.026433] Process irq/62-dwc3 (pid: 303, stack limit = 0x000000003985154c)
[   83.033470] CPU: 0 PID: 303 Comm: irq/62-dwc3 Not tainted 4.19.124 #1
[   83.044836] pstate: 60000085 (nZCv daIf -PAN -UAO)
[   83.049628] pc : dwc3_ep0_handle_feature+0x414/0x43c
[   83.054558] lr : dwc3_ep0_interrupt+0x3b4/0xc94

...

[   83.141788] Call trace:
[   83.144227]  dwc3_ep0_handle_feature+0x414/0x43c
[   83.148823]  dwc3_ep0_interrupt+0x3b4/0xc94
[   83.181546] ---[ end trace aac6b5267d84c32f ]---

Signed-off-by: Marian-Cristian Rotariu <marian.c.rotariu@gmail.com>
Cc: stable <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20210608162650.58426-1-marian.c.rotariu@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/dwc3/ep0.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/usb/dwc3/ep0.c
+++ b/drivers/usb/dwc3/ep0.c
@@ -292,6 +292,9 @@ static struct dwc3_ep *dwc3_wIndex_to_de
 		epnum |= 1;
 
 	dep = dwc->eps[epnum];
+	if (dep == NULL)
+		return NULL;
+
 	if (dep->flags & DWC3_EP_ENABLED)
 		return dep;
 


