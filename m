Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 74A70180414
	for <lists+stable@lfdr.de>; Tue, 10 Mar 2020 17:56:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726571AbgCJQ4i convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Tue, 10 Mar 2020 12:56:38 -0400
Received: from 12.mo6.mail-out.ovh.net ([178.32.125.228]:39841 "EHLO
        12.mo6.mail-out.ovh.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726442AbgCJQ4h (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 Mar 2020 12:56:37 -0400
X-Greylist: delayed 2399 seconds by postgrey-1.27 at vger.kernel.org; Tue, 10 Mar 2020 12:56:36 EDT
Received: from player159.ha.ovh.net (unknown [10.108.57.139])
        by mo6.mail-out.ovh.net (Postfix) with ESMTP id 32068202FEC
        for <stable@vger.kernel.org>; Tue, 10 Mar 2020 16:38:46 +0100 (CET)
Received: from kaod.org (lns-bzn-46-82-253-208-248.adsl.proxad.net [82.253.208.248])
        (Authenticated sender: groug@kaod.org)
        by player159.ha.ovh.net (Postfix) with ESMTPSA id B692E103FFFED;
        Tue, 10 Mar 2020 15:38:42 +0000 (UTC)
Date:   Tue, 10 Mar 2020 16:38:40 +0100
From:   Greg Kurz <groug@kaod.org>
To:     =?UTF-8?B?Q8OpZHJpYw==?= Le Goater <clg@kaod.org>
Cc:     Michael Ellerman <mpe@ellerman.id.au>,
        linuxppc-dev@lists.ozlabs.org, stable@vger.kernel.org
Subject: Re: [PATCH 2/4] powerpc/xive: Fix xmon support on the PowerNV
 platform
Message-ID: <20200310163840.063cd1b3@bahia.home>
In-Reply-To: <20200306150143.5551-3-clg@kaod.org>
References: <20200306150143.5551-1-clg@kaod.org>
        <20200306150143.5551-3-clg@kaod.org>
X-Mailer: Claws Mail 3.17.4 (GTK+ 2.24.32; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-Ovh-Tracer-Id: 13008084576087677323
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: 0
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrgedugedruddvtddgjeegucetufdoteggodetrfdotffvucfrrhhofhhilhgvmecuqfggjfdpvefjgfevmfevgfenuceurghilhhouhhtmecuhedttdenucenucfjughrpeffhffvuffkjghfofggtgfgsehtqhertdertdejnecuhfhrohhmpefirhgvghcumfhurhiiuceoghhrohhugheskhgrohgurdhorhhgqeenucfkpheptddrtddrtddrtddpkedvrddvheefrddvtdekrddvgeeknecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmohguvgepshhmthhpqdhouhhtpdhhvghlohepphhlrgihvghrudehledrhhgrrdhovhhhrdhnvghtpdhinhgvtheptddrtddrtddrtddpmhgrihhlfhhrohhmpehgrhhouhhgsehkrghougdrohhrghdprhgtphhtthhopehsthgrsghlvgesvhhgvghrrdhkvghrnhgvlhdrohhrgh
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri,  6 Mar 2020 16:01:41 +0100
Cédric Le Goater <clg@kaod.org> wrote:

> The PowerNV platform has multiple IRQ chips and the xmon command
> dumping the state of the XIVE interrupt should only operate on the
> XIVE IRQ chip.
> 
> Fixes: 5896163f7f91 ("powerpc/xmon: Improve output of XIVE interrupts")
> Cc: stable@vger.kernel.org # v5.4+
> Signed-off-by: Cédric Le Goater <clg@kaod.org>
> ---

Reviewed-by: Greg Kurz <groug@kaod.org>

>  arch/powerpc/sysdev/xive/common.c | 4 ++++
>  1 file changed, 4 insertions(+)
> 
> diff --git a/arch/powerpc/sysdev/xive/common.c b/arch/powerpc/sysdev/xive/common.c
> index 550baba98ec9..8155adc2225a 100644
> --- a/arch/powerpc/sysdev/xive/common.c
> +++ b/arch/powerpc/sysdev/xive/common.c
> @@ -261,11 +261,15 @@ notrace void xmon_xive_do_dump(int cpu)
>  
>  int xmon_xive_get_irq_config(u32 hw_irq, struct irq_data *d)
>  {
> +	struct irq_chip *chip = irq_data_get_irq_chip(d);
>  	int rc;
>  	u32 target;
>  	u8 prio;
>  	u32 lirq;
>  
> +	if (!is_xive_irq(chip))
> +		return -EINVAL;
> +
>  	rc = xive_ops->get_irq_config(hw_irq, &target, &prio, &lirq);
>  	if (rc) {
>  		xmon_printf("IRQ 0x%08x : no config rc=%d\n", hw_irq, rc);

