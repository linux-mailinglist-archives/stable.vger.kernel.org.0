Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7A4133537CD
	for <lists+stable@lfdr.de>; Sun,  4 Apr 2021 12:49:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230361AbhDDKtS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 4 Apr 2021 06:49:18 -0400
Received: from mo4-p01-ob.smtp.rzone.de ([85.215.255.50]:21356 "EHLO
        mo4-p01-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230180AbhDDKtR (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 4 Apr 2021 06:49:17 -0400
ARC-Seal: i=1; a=rsa-sha256; t=1617533335; cv=none;
    d=strato.com; s=strato-dkim-0002;
    b=s4c01B07/RhoUvJFk1cotrGf78MvDnZt2J45oRrQHmMT3REktuMZPzykKyam/8ToZA
    fox6bznPW6GC37Pvcv8Yjj+oTxd50BXb1yeypO/a5HR1OKd/rYhc5rspxu/X3+9tKOWQ
    lJw0GBkWMMtFH/wpTqOt/e9SAMmdx0HCDePi9N7ts2oEnRG4kACrt4ED2VM4AExBmdUC
    fkr9k67qkNbW3mUatKxxBZkJiKk86bzWJSoOa3vLD09WJSV8eH1w18TxK3REs8uRdbyW
    nyGiZ3UxWDusbbs/dyCX6P1U1cA41if4vpThyvDhOhb1qDE8F9gwJJYblOvBVV/NP3/A
    0haQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; t=1617533335;
    s=strato-dkim-0002; d=strato.com;
    h=To:References:Message-Id:Cc:Date:In-Reply-To:From:Subject:Cc:Date:
    From:Subject:Sender;
    bh=s5PVkddlY0K6VSMM9MdjDmhjZRWQAJNTN3edLUaADU0=;
    b=iAxA/SiAqi/9mps8OY2wXzh8boEi2GNy5nnsrvNPRJwPR/Jb4tMw7Rao09jnRB8qxo
    lMr0fstECFAJD7B7777cf2SHXMBuNg37eAaZsNX98rzxPMjW53+HqkArwiC677skMI6d
    ZsWeqLugMbFleN49mIg8OnTI91oqG5e9N7gDupUg7SYLemNOYis2H7CzayNhGZOWm57V
    PjM8V/FslEs5ww3zphhM7tz+6kH1KhdoNhWRQY4xk0NbyW1VEMfWRaORymYAx6DU1k+x
    EnexH/VhMzeYgwOLYN/k/u5bMf5jpnIfUxPv6RjXqnHJFTPKL275kUMrzBmhia7fEmUz
    PDiA==
ARC-Authentication-Results: i=1; strato.com;
    dkim=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1617533335;
    s=strato-dkim-0002; d=goldelico.com;
    h=To:References:Message-Id:Cc:Date:In-Reply-To:From:Subject:Cc:Date:
    From:Subject:Sender;
    bh=s5PVkddlY0K6VSMM9MdjDmhjZRWQAJNTN3edLUaADU0=;
    b=hv6aGr3ZUW0wLtqHMe8sElZEL24V9aBcU8g9xPqMsCYnQMQ9mAmQE6DhXLiR9BNDMV
    EizYRfpKT+AmjEQ/NieJmv7PcPkFPaW1wRPbPmdXw63xMYCNhP6lvWDCOCRs3wdBwPXA
    xvSBct7OIQ41wBn4nBOtk5LB8T4fPzFyprMNvwu4vr/UcZmvNMJLEPmO2P6UDBnRpikF
    dDq60FPYIlCtbD1B3fQjw1FUwXRb5Nlk8cHe8fSn6nXJIgbzlhw8sXS84Pr85rdOKldP
    77fl5E2ZkpWKmEsFgHegkYvw4hxHyx2EOxo04LlsPRHO+lgCwMjEG075KGEvXYYnznQT
    cGew==
Authentication-Results: strato.com;
    dkim=none
X-RZG-AUTH: ":JGIXVUS7cutRB/49FwqZ7WcJeFKiMgPgp8VKxflSZ1P34KBj7wpz8NMGH/zuwDOioLY="
X-RZG-CLASS-ID: mo00
Received: from imac.fritz.box
    by smtp.strato.de (RZmta 47.23.1 DYNA|AUTH)
    with ESMTPSA id h03350x34Amtbnp
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (curve X9_62_prime256v1 with 256 ECDH bits, eq. 3072 bits RSA))
        (Client did not present a certificate);
    Sun, 4 Apr 2021 12:48:55 +0200 (CEST)
Subject: Re: [BUG]: usb: dwc3: gadget: Prevent EP queuing while stopping transfers
Mime-Version: 1.0 (Mac OS X Mail 9.3 \(3124\))
Content-Type: text/plain; charset=us-ascii
From:   "H. Nikolaus Schaller" <hns@goldelico.com>
In-Reply-To: <YGmOiV7yiQtdaXqD@kroah.com>
Date:   Sun, 4 Apr 2021 12:48:53 +0200
Cc:     Wesley Cheng <wcheng@codeaurora.org>,
        Felipe Balbi <balbi@kernel.org>, stable@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux-OMAP <linux-omap@vger.kernel.org>,
        kernel@pyra-handheld.com,
        Discussions about the Letux Kernel 
        <letux-kernel@openphoenux.org>, linux-usb@vger.kernel.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <7C22FB47-C34A-4E59-89E4-F1854ED737DA@goldelico.com>
References: <DF98BCBA-E13B-4E33-98AD-216816625F3B@goldelico.com> <YGmOiV7yiQtdaXqD@kroah.com>
To:     Greg KH <gregkh@linuxfoundation.org>
X-Mailer: Apple Mail (2.3124)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


> Am 04.04.2021 um 12:01 schrieb Greg KH <gregkh@linuxfoundation.org>:
>=20
> On Sun, Apr 04, 2021 at 11:29:00AM +0200, H. Nikolaus Schaller wrote:
>> it seems as if the patch
>>=20
>> 	9de499997c37 ("usb: dwc3: gadget: Prevent EP queuing while =
stopping transfers") in v5.11.y
>> 	f09ddcfcb8c5 ("usb: dwc3: gadget: Prevent EP queuing while =
stopping transfers") in v5.12-rc5
>>=20
>> reproducible breaks dwc3 RNDIS gadget, at least on the Pyra Handheld =
(OMAP5).
>>=20
>> The symptom of having this patch in tree (v5.11.10 or v5.12) is that
>> rndis/gadget initially works after boot.
>=20
> Should be fixed now by 5aef629704ad ("usb: dwc3: gadget: Clear DEP =
flags
> after stop transfers in ep disable").  Can you test and verify this?

Yes it works. I was no longer able to reproduce the console log.

Thanks for the quick response!

BR,
Nikolaus Schaller

