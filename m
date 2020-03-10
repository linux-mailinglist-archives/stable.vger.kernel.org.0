Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E83D61801DE
	for <lists+stable@lfdr.de>; Tue, 10 Mar 2020 16:31:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726594AbgCJPbj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Mar 2020 11:31:39 -0400
Received: from conssluserg-02.nifty.com ([210.131.2.81]:46015 "EHLO
        conssluserg-02.nifty.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726420AbgCJPbj (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 Mar 2020 11:31:39 -0400
Received: from mail-vk1-f181.google.com (mail-vk1-f181.google.com [209.85.221.181]) (authenticated)
        by conssluserg-02.nifty.com with ESMTP id 02AFVYF4029019;
        Wed, 11 Mar 2020 00:31:34 +0900
DKIM-Filter: OpenDKIM Filter v2.10.3 conssluserg-02.nifty.com 02AFVYF4029019
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nifty.com;
        s=dec2015msa; t=1583854295;
        bh=cU9zGQWEYLmKu3ABbJP9fWNhvET72vVMMuEoK2xZbeA=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=uBFbZowblEtMMMtmmPl1g2DHYesZd0O3dcspp/C1j7pYuuZiW7+A/50a8OxAD9sGX
         3LR/6esVVadbdu8bba9C/iyNdz3dcV1XCPR8GGy8utGuvugcaQ3MEfylMfUIJDhMlc
         NG5vO76Han+PqEgbLSWPcOmKIEPTutMTSJ6dyhq7dpIkAXIgNcot9dq/L918KUFXBu
         q9NuQO9PRXoSuGMXGCJbNN9TfnWlWmC97te5FfbTjQxdYauJy0Gw7S/20R3mgtEzV3
         16OaLPqNErNEHNFQgVtuKtUqoV+aSA0TJIcw56ttliWlmuWvG/pJxx/tbqL5XKtYis
         myG5OlrsN218A==
X-Nifty-SrcIP: [209.85.221.181]
Received: by mail-vk1-f181.google.com with SMTP id i78so3679380vke.0;
        Tue, 10 Mar 2020 08:31:34 -0700 (PDT)
X-Gm-Message-State: ANhLgQ3vCFmusR8luwcYaMMcsI3mZ2mG7fV4UiJqXUPY8wbCJC5dlOnf
        zMTXqPz5XlTk+nd2QFV2Ims2XOVspzBgT7y5L3k=
X-Google-Smtp-Source: ADFU+vshzsYrewZL9/qV8QBmAcUvMQcoFa4yNoeetgkikl+9ovLz5Pmn2O39v6n04YVWO2hgbFnjooVJIw0mOh6UFtA=
X-Received: by 2002:a1f:900c:: with SMTP id s12mr2563486vkd.96.1583854293448;
 Tue, 10 Mar 2020 08:31:33 -0700 (PDT)
MIME-Version: 1.0
References: <20200308073400.23398-1-natechancellor@gmail.com>
 <CAK7LNARcTHpd8fzrAhFVB_AR7NoBgenX64de0eS2uN8g0by9PQ@mail.gmail.com>
 <20200310012545.GA16822@ubuntu-m2-xlarge-x86> <c2a687d065c1463d8eea9947687b3b05@AcuMS.aculab.com>
In-Reply-To: <c2a687d065c1463d8eea9947687b3b05@AcuMS.aculab.com>
From:   Masahiro Yamada <masahiroy@kernel.org>
Date:   Wed, 11 Mar 2020 00:30:57 +0900
X-Gmail-Original-Message-ID: <CAK7LNARMsO0AeO8-kH4czMuW0Y_=dN+ZhtXNdRE7CWGvU2PNvA@mail.gmail.com>
Message-ID: <CAK7LNARMsO0AeO8-kH4czMuW0Y_=dN+ZhtXNdRE7CWGvU2PNvA@mail.gmail.com>
Subject: Re: [PATCH] kbuild: Disable -Wpointer-to-enum-cast
To:     David Laight <David.Laight@aculab.com>
Cc:     Nathan Chancellor <natechancellor@gmail.com>,
        Michal Marek <michal.lkml@markovi.net>,
        Linux Kbuild mailing list <linux-kbuild@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        clang-built-linux <clang-built-linux@googlegroups.com>,
        stable <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Mar 10, 2020 at 8:31 PM David Laight <David.Laight@aculab.com> wrote:
>
> From: Nathan Chancellor
> > Sent: 10 March 2020 01:26
> ...
> > Sure, I can send v2 to do that but I think that sending 97 patches just
> > casting the small values (usually less than twenty) to unsigned long
> > then to the enum is rather frivolous. I audited at least ten to fifteen
> > of these call sites when creating the clang patch and they are all
> > basically false positives.
>
> Such casts just make the code hard to read.
> If misused casts can hide horrid bugs.
> IMHO sprinkling the code with casts just to remove
> compiler warnings will bite back one day.
>

I agree that too much casts make the code hard to read,
but irrespective of this patch, there is no difference
in the fact that we need a cast to convert
(const void *) to a non-pointer value.

The difference is whether we use
(uintptr_t) or (enum foo).




If we want to avoid casts completely,
we could use union in struct of_device_id
although this might be rejected.


FWIW:

diff --git a/drivers/ata/ahci_brcm.c b/drivers/ata/ahci_brcm.c
index 6853dbb4131d..534170bea134 100644
--- a/drivers/ata/ahci_brcm.c
+++ b/drivers/ata/ahci_brcm.c
@@ -415,11 +415,11 @@ static struct scsi_host_template ahci_platform_sht = {
 };

 static const struct of_device_id ahci_of_match[] = {
-       {.compatible = "brcm,bcm7425-ahci", .data = (void *)BRCM_SATA_BCM7425},
-       {.compatible = "brcm,bcm7445-ahci", .data = (void *)BRCM_SATA_BCM7445},
-       {.compatible = "brcm,bcm63138-ahci", .data = (void *)BRCM_SATA_BCM7445},
-       {.compatible = "brcm,bcm-nsp-ahci", .data = (void *)BRCM_SATA_NSP},
-       {.compatible = "brcm,bcm7216-ahci", .data = (void *)BRCM_SATA_BCM7216},
+       {.compatible = "brcm,bcm7425-ahci", .data2 = BRCM_SATA_BCM7425},
+       {.compatible = "brcm,bcm7445-ahci", .data2 = BRCM_SATA_BCM7445},
+       {.compatible = "brcm,bcm63138-ahci", .data2 = BRCM_SATA_BCM7445},
+       {.compatible = "brcm,bcm-nsp-ahci", .data2 = BRCM_SATA_NSP},
+       {.compatible = "brcm,bcm7216-ahci", .data2 = BRCM_SATA_BCM7216},
        {},
 };
 MODULE_DEVICE_TABLE(of, ahci_of_match);
@@ -442,7 +442,7 @@ static int brcm_ahci_probe(struct platform_device *pdev)
        if (!of_id)
                return -ENODEV;

-       priv->version = (enum brcm_ahci_version)of_id->data;
+       priv->version = of_id->data2;
        priv->dev = dev;

        res = platform_get_resource_byname(pdev, IORESOURCE_MEM, "top-ctrl");
diff --git a/include/linux/mod_devicetable.h b/include/linux/mod_devicetable.h
index e3596db077dc..98d44ebf146a 100644
--- a/include/linux/mod_devicetable.h
+++ b/include/linux/mod_devicetable.h
@@ -261,7 +261,10 @@ struct of_device_id {
        char    name[32];
        char    type[32];
        char    compatible[128];
-       const void *data;
+       union {
+               const void *data;
+               unsigned long data2;
+       };
 };

 /* VIO */






-- 
Best Regards
Masahiro Yamada
