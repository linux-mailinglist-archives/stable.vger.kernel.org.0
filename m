Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DF4F24C9029
	for <lists+stable@lfdr.de>; Tue,  1 Mar 2022 17:18:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234486AbiCAQTI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Mar 2022 11:19:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51490 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231880AbiCAQTI (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 1 Mar 2022 11:19:08 -0500
Received: from mout.gmx.net (mout.gmx.net [212.227.17.21])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A7E4027FC1;
        Tue,  1 Mar 2022 08:18:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1646151485;
        bh=GE6GS19/67yYeeIDztfYNxsDMH/T0wk4DthhRy8ejPU=;
        h=X-UI-Sender-Class:Subject:To:Cc:References:From:Date:In-Reply-To;
        b=U7y+jA6LdTzJujUMK3dzljwv/P/RPSkc8GYdzn/zT29MiYk/TXclPyIt2WkLzo3Fz
         QaaeABGOQNTaHqKx6l9jTgCBWGH8ff0yIVxJSqFHkiQh1IWmXHDKxrnKWZ7pbkGtab
         msMU4JCkCx9xKfdLNzgbkjIVDlSvO1qeVpZuRwCk=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from [192.168.178.74] ([149.172.237.68]) by mail.gmx.net (mrgmx105
 [212.227.17.168]) with ESMTPSA (Nemesis) id 1Mlf4c-1o6hTS2tr0-00ikHQ; Tue, 01
 Mar 2022 17:18:04 +0100
Subject: Re: [PATCH v8 1/1] tpm: fix reference counting for struct tpm_chip
To:     Jason Gunthorpe <jgg@ziepe.ca>
Cc:     peterhuewe@gmx.de, jarkko@kernel.org, stefanb@linux.vnet.ibm.com,
        James.Bottomley@hansenpartnership.com, David.Laight@ACULAB.COM,
        linux-integrity@vger.kernel.org, linux-kernel@vger.kernel.org,
        p.rosenberger@kunbus.com,
        Lino Sanfilippo <l.sanfilippo@kunbus.com>,
        stable@vger.kernel.org
References: <20220301022108.30310-1-LinoSanfilippo@gmx.de>
 <20220301022108.30310-2-LinoSanfilippo@gmx.de>
 <20220301140544.GF6468@ziepe.ca>
From:   Lino Sanfilippo <LinoSanfilippo@gmx.de>
Message-ID: <65c85c5e-f1ec-c5fe-7477-e28ce2528fd4@gmx.de>
Date:   Tue, 1 Mar 2022 17:18:03 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20220301140544.GF6468@ziepe.ca>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:nwAQctVcgl9fE4nGE+wKXBDsYDQCaWgBIA8cXCrisbPkeQt47B2
 nmPKtjZcElnwaihQ7+vMokf2+J5s3bYyh2knjZxeZD8myDRLZ5aGQKkmZ9djeHIKdwNJ1ly
 ewLIUBNNNugJJ9oly2un4nZ/Sode0dlLkjf9Gm/Ntxy0gsPD0PqS+nXgOgJAQT4cc77nK4u
 UpQ7vKSQXfYuh5CR/VpcA==
X-UI-Out-Filterresults: notjunk:1;V03:K0:/evx627867g=:h2bMDGki3tNTvJeSC47xjm
 YT2jOIT5na0YxziUccoemGvk09q2jbizZgrpSevssuuc3pzXdAY2gE9GM0VOX3Wl7/H16zOsj
 wSWlTROL5KwVZ4Zn5ERcNNBrWnXefWacIOxNj2reNOF/K8N/fsaga+QFvSOthrPxcXjIRVE70
 2JTv6pp5SwEW4Oi1nwjB6oDCaYHEaHfuFOdXZxq9A2W0UNyXQ9X0UP7AHL0HPF8W/3Te3fVe9
 H022Jcq7e/+tW+N0k6zzAXvGQb+rdko11Piy/PeapcVuEylv0XpsWmYBylxeZ2Qjcsuu4N+ei
 MCgi2to7EKo/qQxC++1w2pFRz5FZqb1tuen44DTPz4iMJUvD+LyoZT+aJ3R8/VYBBxl+JY1aC
 nvKSZYunySJRrr7SR5P8JI+Zyq9k7KbDFTSB7YBluLcUPNJQLzHLvC+W9uo60ZYmpvJFsnNRk
 cH1KhXetgI2MVrLCBVcS+JahGUbwuoNCaWXmcNQIW4xzbbcGEiov3dyQq3Q9q7ASbPJJRk/eq
 hZsNlj3laHNx4b/CJh2eUsA0OYjO3dg6WHQ0aqO4WiLTivHhZME9v8T5ea3KaPKml89lRFsQj
 OQfZI9LtPoXv2DkRrbdhP55D3J7LAI648gva/hKehd7BltHMQqBmyYYWMVR8zB8Z/r0EcsfYt
 EKJme17Dzp7nz40pzVFKMLpzwax6WmZ0D0CJIXm8+ONy0XrVfIAk+HWfyQeKY/kc176ziYEk3
 Uizrp4IOYu49zdb11a6cVdQ9zlR9onZ/7+L2aol5KD9KhIEG3GMPOzWYFRw+BDjbf5OY644Pc
 xCPL7T+qM2irVLdZ0GL2lNyucsFzlske6bS4iLkLEAn+ovJZ3M/wzQyp77TMf3JYEOUPps07l
 pTrN3H++8G6R1zqZejdQ2Vrlwq5wCEXAcIyT6MVIqHSYfs1RrTxMisdccjcFwBl1TFsc5i2as
 SrkAJaiK4AJWlMTS1QrkTj7AziOKmYCGm7YQuOiSgmvpCq3rnhfQ6TiKDFvakk208/7b44ciI
 pVNbXCXuKGhCxEJUudOQMh4hRTd/pU2NUdCxLPrU68IwDVcbT11LFYlQDeiBPwR/I/0mZrwXG
 bmV2Pu4FFcnBFA=
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,FREEMAIL_FROM,NICE_REPLY_A,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 01.03.22 at 15:05, Jason Gunthorpe wrote:
> On Tue, Mar 01, 2022 at 03:21:08AM +0100, Lino Sanfilippo wrote:
>> @@ -653,8 +623,10 @@ void tpm_chip_unregister(struct tpm_chip *chip)
>>  	if (IS_ENABLED(CONFIG_HW_RANDOM_TPM) && !tpm_is_firmware_upgrade(chip=
))
>>  		hwrng_unregister(&chip->hwrng);
>>  	tpm_bios_log_teardown(chip);
>> -	if (chip->flags & TPM_CHIP_FLAG_TPM2 && !tpm_is_firmware_upgrade(chip=
))
>> +	if (chip->flags & TPM_CHIP_FLAG_TPM2 && !tpm_is_firmware_upgrade(chip=
)) {
>>  		cdev_device_del(&chip->cdevs, &chip->devs);
>> +		put_device(&chip->devs);
>> +	}
>
> I would put those two lines in a function bside tpm_devs_add() as
> well, more modular.
>

Agreed, I will put this in a tpm_devs_remove() function as counterpart to =
tpm_devs_add().

Regards,
Lino

