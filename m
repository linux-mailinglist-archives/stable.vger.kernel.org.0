Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 08EB865327C
	for <lists+stable@lfdr.de>; Wed, 21 Dec 2022 15:29:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231263AbiLUO3S (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 21 Dec 2022 09:29:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33910 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229789AbiLUO3Q (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 21 Dec 2022 09:29:16 -0500
Received: from radex-web.radex.nl (smtp.radex.nl [178.250.146.7])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 3967313D;
        Wed, 21 Dec 2022 06:29:10 -0800 (PST)
Received: from [192.168.1.35] (cust-178-250-146-69.breedbanddelft.nl [178.250.146.69])
        by radex-web.radex.nl (Postfix) with ESMTPS id 03E77240A8;
        Wed, 21 Dec 2022 15:29:10 +0100 (CET)
Message-ID: <b6692501-5c6e-945a-9a54-986ae8dd1687@gmail.com>
Date:   Wed, 21 Dec 2022 15:29:09 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.0
Subject: Re: [PATCH v5 1/2] usb: ulpi: defer ulpi_register on ulpi_read_id
 timeout
Content-Language: en-US
To:     Guenter Roeck <linux@roeck-us.net>, Ferry Toth <fntoth@gmail.com>
Cc:     linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Thinh Nguyen <Thinh.Nguyen@synopsys.com>,
        Sean Anderson <sean.anderson@seco.com>,
        Liu Shixin <liushixin2@huawei.com>,
        Andrey Smirnov <andrew.smirnov@gmail.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        stable@vger.kernel.org
References: <20221205201527.13525-1-ftoth@exalondelft.nl>
 <20221205201527.13525-2-ftoth@exalondelft.nl>
 <20221220194334.GA942039@roeck-us.net>
 <4d6f0bdb-500b-7ae5-ef10-a844a7abbf23@gmail.com>
 <20221221124104.GB1353152@roeck-us.net>
From:   Ferry Toth <fntoth@gmail.com>
In-Reply-To: <20221221124104.GB1353152@roeck-us.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-0.5 required=5.0 tests=BAYES_00,DKIM_ADSP_CUSTOM_MED,
        FORGED_GMAIL_RCVD,FREEMAIL_FROM,NICE_REPLY_A,NML_ADSP_CUSTOM_MED,
        SPF_HELO_NONE,SPF_SOFTFAIL autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi

On 21-12-2022 13:41, Guenter Roeck wrote:
> On Wed, Dec 21, 2022 at 11:07:50AM +0100, Ferry Toth wrote:
>> Hi,
>>
>> On 20-12-2022 20:43, Guenter Roeck wrote:
>>> On Mon, Dec 05, 2022 at 09:15:26PM +0100, Ferry Toth wrote:
>>>> Since commit 0f0101719138 ("usb: dwc3: Don't switch OTG -> peripheral
>>>> if extcon is present") Dual Role support on Intel Merrifield platform
>>>> broke due to rearranging the call to dwc3_get_extcon().
>>>>
>>>> It appears to be caused by ulpi_read_id() on the first test write failing
>>>> with -ETIMEDOUT. Currently ulpi_read_id() expects to discover the phy via
>>>> DT when the test write fails and returns 0 in that case, even if DT does not
>>>> provide the phy. As a result usb probe completes without phy.
>>>>
>>>> Make ulpi_read_id() return -ETIMEDOUT to its user if the first test write
>>>> fails. The user should then handle it appropriately. A follow up patch
>>>> will make dwc3_core_init() set -EPROBE_DEFER in this case and bail out.
>>>>
>>>> Fixes: ef6a7bcfb01c ("usb: ulpi: Support device discovery via DT")
>>>> Cc: stable@vger.kernel.org
>>>> Signed-off-by: Ferry Toth <ftoth@exalondelft.nl>
>>> Hi,
>>>
>>> this patch results in some qemu test failures, specifically xilinx-zynq-a9
>>> machine and zynq-zc702 as well as zynq-zed devicetree files, when trying
>>> to boot from USB drive. The log shows
>> I'm not familiar with that platform. Does it use dt to discover the ulpi
>> device?
>>
> The dt usb description includes
>
> 	usb_phy0: phy0 {
>                  compatible = "usb-nop-xceiv";
>                  #phy-cells = <0>;
>          };
>
> ...
>
> &usb0 {
>          status = "okay";
>          dr_mode = "host";
>          usb-phy = <&usb_phy0>;
> };
>
> ...
>
>                  usb0: usb@e0002000 {
>                          compatible = "xlnx,zynq-usb-2.20a", "chipidea,usb2";
>                          status = "disabled";
>                          clocks = <&clkc 28>;
>                          interrupt-parent = <&intc>;
>                          interrupts = <0 21 4>;
>                          reg = <0xe0002000 0x1000>;
>                          phy_type = "ulpi";
>                  };
>
> The chipidea core initialization code includes
>
>          if (!platdata->phy_mode)
>                  platdata->phy_mode = of_usb_get_phy_mode(dev->of_node);
>
> Does that mean that every chipidea based usb implementation specifying
> 	phy_type = "ulpi";
> in their devicetree description will now fail, plus maybe others
> who determine the phy mode from devicetree ?
I don't think so.
>> I'm guessing that the problem is actually caused by "usb: ulpi: defer
>> ulpi_register on ulpi_read_id timeout".
>>
> Confused. Isn't that this patch ?
Ehem. Yes.
>> ulpi_read_id() now returns ETIMEDOUT due to the test write ulpi_write(ulpi,
>> ULPI_SCRATCH, 0xaa) failing.
>>
>> Maybe  we can create a fix by skipping the test write in case dt discovery
>> is available and calling of_device_request_module() directly, instead of
>> masking the timed out test write as it was before?
>>
> I have no idea. All I can see is that it appears that there was a reason
> for not returning an error if that test write failed.

It seems to have been a quick patch to solve a power sequencing issue:

"The ULPI bus code supports native enumeration by reading the
vendor ID and product ID registers at device creation time, but
we can't be certain that those register reads will succeed if the
phy is not powered up. To avoid any problems with reading the ID
registers before the phy is powered we fallback to DT matching
when the ID reads fail.

If the ULPI spec had some generic power sequencing for these
registers we could put that into the ULPI bus layer and power up
the device before reading the ID registers. Unfortunately this
doesn't exist and the power sequence is usually device specific.
By having the device matched up with DT we can avoid this
problem."

But as is, the code now requires a DT when there is a power
sequencing issue, which is wrong for Merrifield. It seems my patch
breaks the OF path, by replacing that by a deferred probe.

I'm thinking the correct way would be:
- if present use DT
- else if test write fails, defer probe
- else enumeration by reading the vendor ID and product ID registers

>
> Thanks,
> Guenter
>
>>> ci_hdrc ci_hdrc.0: failed to register ULPI interface
>>> ci_hdrc: probe of ci_hdrc.0 failed with error -110
>>>
>>> and the USB interface does not instantiate. Reverting this patch fixes
>>> the problem. Bisect log is attached.
>>>
>>> A detailed log is available at
>>> https://kerneltests.org/builders/qemu-arm-v7-master/builds/484/steps/qemubuildcommand/logs/stdio
>>>
>>> Guenter
>>>
>>> ---
>>> # bad: [35f79d0e2c98ff6ecb9b5fc33113158dc7f7353c] Merge tag 'parisc-for-6.2-1' of git://git.kernel.org/pub/scm/linux/kernel/git/deller/parisc-linux
>>> # good: [830b3c68c1fb1e9176028d02ef86f3cf76aa2476] Linux 6.1
>>> git bisect start 'HEAD' 'v6.1'
>>> # good: [90b12f423d3c8a89424c7bdde18e1923dfd0941e] Merge tag 'for-linus-6.2-1' of https://github.com/cminyard/linux-ipmi
>>> git bisect good 90b12f423d3c8a89424c7bdde18e1923dfd0941e
>>> # good: [c7020e1b346d5840e93b58cc4f2c67fc645d8df9] Merge tag 'pci-v6.2-changes' of git://git.kernel.org/pub/scm/linux/kernel/git/helgaas/pci
>>> git bisect good c7020e1b346d5840e93b58cc4f2c67fc645d8df9
>>> # bad: [b83a7080d30032cf70832bc2bb04cc342e203b88] Merge tag 'staging-6.2-rc1' of git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/staging
>>> git bisect bad b83a7080d30032cf70832bc2bb04cc342e203b88
>>> # good: [057b40f43ce429a02e793adf3cfbf2446a19a38e] Merge tag 'acpi-6.2-rc1-2' of git://git.kernel.org/pub/scm/linux/kernel/git/rafael/linux-pm
>>> git bisect good 057b40f43ce429a02e793adf3cfbf2446a19a38e
>>> # good: [851f657a86421dded42b6175c6ea0f4f5e86af97] Merge tag '6.2-rc-smb3-client-fixes-part1' of git://git.samba.org/sfrench/cifs-2.6
>>> git bisect good 851f657a86421dded42b6175c6ea0f4f5e86af97
>>> # good: [fa205589d5e9fc2d1b2f8d31f665152da04160bc] staging: r8188eu: stop beacon processing if kmalloc fails
>>> git bisect good fa205589d5e9fc2d1b2f8d31f665152da04160bc
>>> # good: [4051a1c96e4883f3445cc8f239c214be622f4c6c] Merge tag 'thunderbolt-for-v6.2-rc1' of git://git.kernel.org/pub/scm/linux/kernel/git/westeri/thunderbolt into usb-next
>>> git bisect good 4051a1c96e4883f3445cc8f239c214be622f4c6c
>>> # good: [84e57d292203a45c96dbcb2e6be9dd80961d981a] Merge tag 'exfat-for-6.2-rc1' of git://git.kernel.org/pub/scm/linux/kernel/git/linkinjeon/exfat
>>> git bisect good 84e57d292203a45c96dbcb2e6be9dd80961d981a
>>> # good: [6f1f0ad910f73f5533b65e1748448d334e0ec697] usb: gadget: udc: drop obsolete dependencies on COMPILE_TEST
>>> git bisect good 6f1f0ad910f73f5533b65e1748448d334e0ec697
>>> # good: [c7912f27dedd874d49eadf78b5b6fbfdec52c7c3] staging: rtl8192e: Fix spelling mistake "ContryIE" -> "CountryIE"
>>> git bisect good c7912f27dedd874d49eadf78b5b6fbfdec52c7c3
>>> # bad: [63130462c919ece0ad0d9bb5a1f795ef8d79687e] usb: dwc3: core: defer probe on ulpi_read_id timeout
>>> git bisect bad 63130462c919ece0ad0d9bb5a1f795ef8d79687e
>>> # good: [38cea8e31e9ef143187135d714aed4d7bd18463c] dt-bindings: vendor-prefixes: add Genesys Logic
>>> git bisect good 38cea8e31e9ef143187135d714aed4d7bd18463c
>>> # good: [9bae996ffa28ac03b6d95382a2a082eb219e745a] usb: misc: onboard_usb_hub: add Genesys Logic GL850G hub support
>>> git bisect good 9bae996ffa28ac03b6d95382a2a082eb219e745a
>>> # bad: [8a7b31d545d3a15f0e6f5984ae16f0ca4fd76aac] usb: ulpi: defer ulpi_register on ulpi_read_id timeout
>>> git bisect bad 8a7b31d545d3a15f0e6f5984ae16f0ca4fd76aac
>>> # first bad commit: [8a7b31d545d3a15f0e6f5984ae16f0ca4fd76aac] usb: ulpi: defer ulpi_register on ulpi_read_id timeout
