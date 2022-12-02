Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 175EF640940
	for <lists+stable@lfdr.de>; Fri,  2 Dec 2022 16:23:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233357AbiLBPXf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 2 Dec 2022 10:23:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58730 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233309AbiLBPXe (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 2 Dec 2022 10:23:34 -0500
Received: from phobos.denx.de (phobos.denx.de [85.214.62.61])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D1CA8CEF8D
        for <stable@vger.kernel.org>; Fri,  2 Dec 2022 07:23:32 -0800 (PST)
Received: from [127.0.0.1] (p578adb1c.dip0.t-ipconnect.de [87.138.219.28])
        (using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: marex@denx.de)
        by phobos.denx.de (Postfix) with ESMTPSA id 4C5A482A0A;
        Fri,  2 Dec 2022 16:23:30 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=denx.de;
        s=phobos-20191101; t=1669994611;
        bh=FjNc72d88EtpHVUFPRlV9jQ4MgH1XMswRIXxAkTYQqE=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=yTMVKYBpiaA3apV+F/BKc+U5iNWDA2lUgnnvv0wdQ21WLmQAhbwGdPZe9zCHOiI6i
         or/dlonUdzHh/J6LbQRiRgFnRe7Zet0734Dqm6SUSMWj1NgqyJhWlEJU6u8hAgd9c7
         0KJrUa8SKlNXFWCPkd6WGwWsnqJu/GujuWTocNCr4cDSXJ+mZO3yYA6xxg/Az7B2my
         JbZsCJ8tE+Yh5RT8t5/73DFjymBuyLFGJbtUizVCZxMp6cn1bq+O5E6CfqSpDA+h9u
         DYNOg1dtdbxxRUqDnSQ49aUYJOknFyvLjVTSBTxtlUlvUoFu3rz3I0scwOPSaBRa65
         ZvJC2DUs6/odQ==
Message-ID: <223b7a4e-3aff-8070-7387-c77d2ded1dd6@denx.de>
Date:   Fri, 2 Dec 2022 16:23:29 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.0
Subject: Re: [PATCH v1] mtd: parsers: ofpart: Fix parsing when size-cells is 0
Content-Language: en-US
To:     Miquel Raynal <miquel.raynal@bootlin.com>
Cc:     Francesco Dolcini <francesco@dolcini.it>,
        Richard Weinberger <richard@nod.at>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        linux-mtd@lists.infradead.org,
        Francesco Dolcini <francesco.dolcini@toradex.com>,
        Shawn Guo <shawnguo@kernel.org>,
        linux-arm-kernel@lists.infradead.org, stable@vger.kernel.org,
        u-boot@lists.denx.de
References: <20221202071900.1143950-1-francesco@dolcini.it>
 <20221202101418.6b4b3711@xps-13>
 <Y4nPmzdgaabg3a3/@francesco-nb.int.toradex.com>
 <Y4nSXQirO2N5IRfu@francesco-nb.int.toradex.com>
 <20221202115327.4475d3a2@xps-13>
 <Y4ngOaKq224LIpQc@francesco-nb.int.toradex.com>
 <20221202150556.14c5ae43@xps-13>
 <2b6fc52d-60b9-d0f4-ab91-4cf7a8095999@denx.de>
 <20221202160030.1b8d0b8a@xps-13>
From:   Marek Vasut <marex@denx.de>
In-Reply-To: <20221202160030.1b8d0b8a@xps-13>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Virus-Scanned: clamav-milter 0.103.6 at phobos.denx.de
X-Virus-Status: Clean
X-Spam-Status: No, score=-4.7 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 12/2/22 16:00, Miquel Raynal wrote:
> Hi Marek,

Hi,

> marex@denx.de wrote on Fri, 2 Dec 2022 15:31:40 +0100:
> 
>> On 12/2/22 15:05, Miquel Raynal wrote:
>>> Hi Francesco,
>>
>> Hi,
>>
>> [...]
>>
>>> I still strongly disagree with the initial proposal but what I think we
>>> can do is:
>>>
>>> 1. To prevent future breakages:
>>>     Fix fdt_fixup_mtdparts() in u-boot. This way newer U-Boot + any
>>>     kernel should work.
>>>
>>> 2. To help tracking down situations like that:
>>>     Keep the warning in ofpart.c but continue to fail.
>>>
>>> 3. To fix the current situation:
>>>      Immediately revert commit (and prevent it from being backported):
>>>      753395ea1e45 ("ARM: dts: imx7: Fix NAND controller size-cells")
>>>      This way your own boot flow is fixed in the short term.
>>
>> Here I disagree, the fix is correct and I think we shouldn't
>> proliferate incorrect DTs which don't match the binding document.
> 
> I agree we should not proliferate incorrect DTs, so let's use a modern
> description then

Yes please !

> , with a controller and a child node which defines the
> chip.

But what if there is no chip connected to the controller node ?

If I understand the proposal here right (please correct me if I'm 
wrong), then:

1) This is the original, old, wrong binding:
&gpmi {
   #size-cells = <1>;
   ...
   partition@N { ... };
};


2) This is the newer, but still wrong binding:
&gpmi {
   #size-cells = <0>;
   ...
   partitions {
     partition@N { ... };
   };
};

3) This is the newest binding, what we want:
&gpmi {
   #size-cells = <0>;
   ...
   nand-chip {
     partitions {
       partition@N { ... };
     };
   };
};

But if there is no physical nand chip connected to the controller, would 
we end up with empty nand-chip node in DT, like this?
&gpmi {
   #size-cells = <X>;
   ...
   nand-chip { /* empty */ };
};
What would be the gpmi controller size cells (X) in that case, still 0, 
right ? So how does that help solve this problem, wouldn't U-Boot still 
populate the partitions directly under the gpmi node or into partitions 
sub-node ?

>> Rather, if a bootloader generates incorrect (new) DT entries, I
>> believe the driver should implement a fixup and warn user about this.
>> PC does that as well with broken ACPI tables as far as I can tell.
>>
>> I'm not convinced making a DT non-compliant with bindings again,
> 
> I am sorry to say so, but while warnings reported by the tools
> should be fixed, it's not because the tool does not scream at you that
> the description is valid. We are actively working on enhancing the
> schema so that "all" improper descriptions get warnings (see the series
> pointed earlier), but in no way this change makes the node compliant
> with modern bindings.
> 
> I'm not saying the fix is wrong, but let's be pragmatic, it currently
> leads to boot failures.

I fully agree that we do have a problem, and that it trickled into 
stable makes it even worse. Maybe I don't fully understand the thing 
with nand-chip proposal, see my question above, esp. the last part.

>> only to work around a problem induced by bootloader, is the right approach
>> here.
> 
> When a patch breaks a board and there is no straight fix, you revert
> it, then you think harder. That's what I am saying. This is a temporary
> solution.

Isn't this patch the straight fix, at least until the bootloader can be 
updated to generate the nand-chip node correctly ?

>> This would be setting a dangerous example, where anyone could request a DT fix to be reverted because their random bootloader does the wrong thing and with valid DT clean up, something broke.
> 
> Please, you know this is not valid DT clean up. We've been decoupling
> controller and chip description since 2016. What I am proposing is a
> valid DT cleanup, not to the latest standard, but way closer than the
> current solution.

I think I really need one more explanation of the nand-chip part above.

[...]
