Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E26F1E9830
	for <lists+stable@lfdr.de>; Wed, 30 Oct 2019 09:30:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726073AbfJ3IaU convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Wed, 30 Oct 2019 04:30:20 -0400
Received: from mail-ot1-f67.google.com ([209.85.210.67]:40983 "EHLO
        mail-ot1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726063AbfJ3IaU (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 30 Oct 2019 04:30:20 -0400
Received: by mail-ot1-f67.google.com with SMTP id 94so1352755oty.8;
        Wed, 30 Oct 2019 01:30:19 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=shaH6wyN32drrguPI+9Ka7J8m35ewqocN24h2TWk6Ig=;
        b=bnUB0zeYPnBP/TGMcOO/i61FnrZekgN/msG9b/Lyz+6l7d4X2zPq3bFQzZh6RAtgis
         ouW+COUUKLWAPc/tUiblitJjIFCZUZK21HKz4+5S6IOT8IkgyAyAa3gW7P9aFP+4jR0b
         sbASaxc26ULZsrrcMyMLhqKxobh7F1Hi5HrRDQVwU04PbjQx0g+7AZ5c6JMF1/nVRlHQ
         OZQHZM/zAsRkpvw7a7WGZDZyXgC1wG4SrIgpa1ZHKOPHT/qQh9UQezoqlORinBC2UhQV
         8H5kqkkxxSBqSWnTGkP+6XoHvVCRUpO+D8h5HPDgfzS9juUqG1QTrJ8+Arhj5Vxtsans
         XlnA==
X-Gm-Message-State: APjAAAWvhJDNZUdxNq28Y3ILQKqbnA9QcYRXO7YW9E4NUlmD7pXSwzqR
        OrztGgKqpKwAQX2XOhptESxEOc69mg2On1bVg/8=
X-Google-Smtp-Source: APXvYqzKCLMaWvbhAzJd4Mbqecnc5FnVdcMo+ZI6kUn/bYWdI5LaTSfzEByozgHdvHKWt9J/YtslquCxPdHC+5Eyi8U=
X-Received: by 2002:a9d:7d19:: with SMTP id v25mr18567689otn.250.1572424218495;
 Wed, 30 Oct 2019 01:30:18 -0700 (PDT)
MIME-Version: 1.0
References: <1570769432-15358-1-git-send-email-yoshihiro.shimoda.uh@renesas.com>
 <20191029143753.GA28404@vmlxhi-102.adit-jv.com> <TYAPR01MB45441F470C83E7CAEF4D72E0D8600@TYAPR01MB4544.jpnprd01.prod.outlook.com>
In-Reply-To: <TYAPR01MB45441F470C83E7CAEF4D72E0D8600@TYAPR01MB4544.jpnprd01.prod.outlook.com>
From:   Geert Uytterhoeven <geert@linux-m68k.org>
Date:   Wed, 30 Oct 2019 09:30:06 +0100
Message-ID: <CAMuHMdXxhrJ0bqGi3JZkjgrr7=p-_NfA7Lmd8q32=Ho4tEXw0A@mail.gmail.com>
Subject: Re: [PATCH v4] PCI: rcar: Fix missing MACCTLR register setting in rcar_pcie_hw_init()
To:     Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
Cc:     "REE erosca@DE.ADIT-JV.COM" <erosca@de.adit-jv.com>,
        Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        "horms@verge.net.au" <horms@verge.net.au>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-renesas-soc@vger.kernel.org" 
        <linux-renesas-soc@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Yohhei Fukui <yohhei.fukui@denso-ten.com>,
        Asano Yasushi <yasano@jp.adit-jv.com>,
        Steffen Pengel <spengel@jp.adit-jv.com>,
        Andrew Gabbasov <andrew_gabbasov@mentor.com>,
        Eugeniu Rosca <roscaeugeniu@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Shimoda-san,

On Wed, Oct 30, 2019 at 3:15 AM Yoshihiro Shimoda
<yoshihiro.shimoda.uh@renesas.com> wrote:
> > From: Eugeniu Rosca, Sent: Tuesday, October 29, 2019 11:38 PM
> > On Fri, Oct 11, 2019 at 01:50:32PM +0900, Yoshihiro Shimoda wrote:
> > > According to the R-Car Gen2/3 manual, the bit 0 of MACCTLR register
> > > should be written to 0 before enabling PCIETCTLR.CFINIT because
> > > the bit 0 is set to 1 on reset. To avoid unexpected behaviors from
> > > this incorrect setting, this patch fixes it.
> >
> > Your development and reviewing effort to reach v4 is very appreciated.
> >
> > However, in the context of some internal reviews of this patch, we are
> > having hard times reconciling the change with our (possibly incomplete
> > or inaccurate) interpretation of the R-Car3 HW User’s Manual (Rev.2.00
> > Jul 2019). The latter says in
> > Chapter "54. PCIE Controller" / "(2) Initial Setting of PCI Express":
> >
> >  ----snip----
> >  Be sure to write the initial value (= H'80FF 0000) to MACCTLR before
> >  enabling PCIETCTLR.CFINIT.
> >  ----snip----
> >
> > Is my assumption correct that the description of this patch is a
> > rewording of the above quote from the manual <snip>
>
> You are correct. Since the reset value of MACCTLR is H'80FF 0001, I thought
> clearing the LSB bit was enough.
> However, as your situation, I think I should have described the above quote
> from the manual and have such a code (writing the value instead of clearing
> the LSB only).
>
> > If it is only the LSB which "should be written to 0 before enabling
> > PCIETCTLR.CFINIT", would you agree that the statement quoted from the
> > manual would better be rephrased appropriately? TIA.
>
> As I mentioned above, I think the above quote from the manual is better
> than rephrased.
>
> Sergei, Geert-san, I think we should revert this patch and fix code/commit
> log to follow the manual. What do you think?

The initial value mentioned in the manual makes sense to me.
Of course when using that, #defines should be added for bits used, to
avoid writing the magical value "0x80ff0001".

Initially, the "ff" part worried me.  Fortunately some archaeology learned
me that these bits where called "NFTS" in the SH7786 Hardware User's
Manual, and used to specify the number of Fast Training Sequences to
be transferred when the MAC returns from L0 to L0s (6--255).

arch/sh/drivers/pci/pcie-sh7786.c seems to be aware of this:

        /*
         * Set fast training sequences to the maximum 255,
         * and enable MAC data scrambling.
         */
        data = pci_read_reg(chan, SH4A_PCIEMACCTLR);
        data &= ~PCIEMACCTLR_SCR_DIS;
        data |= (0xff << 16);
        pci_write_reg(chan, data, SH4A_PCIEMACCTLR);

No idea why this was deemed not-to-be-modified by the user later
(as of R-Car H1).

Gr{oetje,eeting}s,

                        Geert

-- 
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
