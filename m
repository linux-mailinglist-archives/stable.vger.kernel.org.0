Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6110A22AFE3
	for <lists+stable@lfdr.de>; Thu, 23 Jul 2020 15:03:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728849AbgGWND5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Jul 2020 09:03:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36022 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727859AbgGWND5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 Jul 2020 09:03:57 -0400
Received: from mail-lj1-x244.google.com (mail-lj1-x244.google.com [IPv6:2a00:1450:4864:20::244])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B6DEC0619DC;
        Thu, 23 Jul 2020 06:03:55 -0700 (PDT)
Received: by mail-lj1-x244.google.com with SMTP id r19so6202115ljn.12;
        Thu, 23 Jul 2020 06:03:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:in-reply-to:references:date:message-id
         :mime-version;
        bh=LJEiKpz9gp0StAjHhoJ8pMMagIDPpkqONOHADySk4U4=;
        b=YEzntdnUXljzr15iYUbd6vBzxKa267iPGPD/lVBvxqTTEwKSO7OuvVL+CYq4ppbo7R
         W3dy8IK/C9LyYhF3QOqQXs6JWhdKxBX4qdPnawLzvwpMcR2ytmiTHbVHrA+DAetqje9r
         jyGVel+Sl6xbQnXTjtyWHZXZ5GQrqQf/z24JPZzOz3iiUgDUKmbxEFZ/ozkTXlnjLZEo
         XR642R1fCqfbHPhAqyIoUrQ2vmh2SRcDguX5zwiu1aOLZTc1+5PNhEi+sCSZRA+gxa07
         +mhIW0Lwj7TnlNoLblwV4CwTGhL6dBckanWyWZCiczl1obxIGAPuclV5G6Go0B+Gr/uF
         6yww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:in-reply-to:references
         :date:message-id:mime-version;
        bh=LJEiKpz9gp0StAjHhoJ8pMMagIDPpkqONOHADySk4U4=;
        b=joemrnRYuiynWnhyGxpINmf7Rbw6uHbQrpxXOGcRktO8zP8qfr22mKeR+RdbQsdFgj
         O+ZaX7D0+RZyJozhzq+hzHZ+e4YpbC0AdyVdQv51C5G8cexBfePpQpn8TKjc+rI59Il7
         WFlKGAJZn3ymxYyhAVZ6nR/53QT71cGcRMstfEkIrOht5xBBmCfH3vaYweRCdPUtBxE+
         BKJUA4b+N7sVapJ8jxwveWkxC+GvDQv/M4TqQJEPCzhXGIz2PT+y+u6MXLffBLEs2nir
         DQw3we6xW+a4nBod4H7CtccLzvvEhX/Y7fZ27PXy6laY7p5dtIIC0mxZ2VV1Lhwp4udm
         eqXQ==
X-Gm-Message-State: AOAM530uHzgPFW7ILySrcfOvb0sefWnoYrRLMDVgvdhMwwl96tqeUFKx
        2yLBX0SG4X5kwBGsjCYfJqNnRWmM7/lApQ==
X-Google-Smtp-Source: ABdhPJxCwiR2AKqYY6rSABJHjcYSrfJ+FUm4ZucYt8nRU6zBJR3m4T8FUl37r7vmIHub8TT1WAi28w==
X-Received: by 2002:a2e:b17a:: with SMTP id a26mr1871564ljm.342.1595509429663;
        Thu, 23 Jul 2020 06:03:49 -0700 (PDT)
Received: from saruman (91-155-214-58.elisa-laajakaista.fi. [91.155.214.58])
        by smtp.gmail.com with ESMTPSA id k14sm2742886ljc.48.2020.07.23.06.03.48
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 23 Jul 2020 06:03:48 -0700 (PDT)
From:   Felipe Balbi <balbi@kernel.org>
To:     Minas Harutyunyan <Minas.Harutyunyan@synopsys.com>,
        Martin Blumenstingl <martin.blumenstingl@googlemail.com>,
        "gregkh\@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "linux-usb\@vger.kernel.org" <linux-usb@vger.kernel.org>
Cc:     "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "marex\@denx.de" <marex@denx.de>,
        "stable\@vger.kernel.org" <stable@vger.kernel.org>
Subject: Re: [RFC for-5.8] usb: dwc2: Cleanup debugfs when usb_add_gadget_udc() fails
In-Reply-To: <0ba4b7ce-3551-0453-bac7-4d86c53dd2e8@synopsys.com>
References: <20200629180314.2878638-1-martin.blumenstingl@googlemail.com> <0ba4b7ce-3551-0453-bac7-4d86c53dd2e8@synopsys.com>
Date:   Thu, 23 Jul 2020 16:03:44 +0300
Message-ID: <87eep2o027.fsf@kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha256; protocol="application/pgp-signature"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Minas Harutyunyan <Minas.Harutyunyan@synopsys.com> writes:

> Hi Martin,
>
> On 6/29/2020 10:03 PM, Martin Blumenstingl wrote:
>> Call dwc2_debugfs_exit() when usb_add_gadget_udc() has failed. This
>> ensure that the debugfs entries created by dwc2_debugfs_init() are
>> cleaned up in the error path.
>>=20
>> Fixes: 207324a321a866 ("usb: dwc2: Postponed gadget registration to the =
udc class driver")
>> Signed-off-by: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
>> ---
>> This patch is compile-tested only. I found this while trying to
>> understand the latest changes to dwc2/platform.c.
>>=20
>>=20
>>   drivers/usb/dwc2/platform.c | 4 +++-
>>   1 file changed, 3 insertions(+), 1 deletion(-)
>>=20
>> diff --git a/drivers/usb/dwc2/platform.c b/drivers/usb/dwc2/platform.c
>> index c347d93eae64..02b6da7e21d7 100644
>> --- a/drivers/usb/dwc2/platform.c
>> +++ b/drivers/usb/dwc2/platform.c
>> @@ -582,12 +582,14 @@ static int dwc2_driver_probe(struct platform_devic=
e *dev)
>>   		retval =3D usb_add_gadget_udc(hsotg->dev, &hsotg->gadget);
>>   		if (retval) {
>>   			dwc2_hsotg_remove(hsotg);
>> -			goto error_init;
>> +			goto error_debugfs;
>>   		}
>>   	}
>>   #endif /* CONFIG_USB_DWC2_PERIPHERAL || CONFIG_USB_DWC2_DUAL_ROLE */
>>   	return 0;
>>=20=20=20
>> +error_debugfs:
>> +	dwc2_debugfs_exit(hsotg);
>>   error_init:
>>   	if (hsotg->params.activate_stm_id_vb_detection)
>>   		regulator_disable(hsotg->usb33d);
>>=20
> I'm Ok with this fix. One more thing. I missed to remove hcd also in=20
> fail case. Could you please add dwc2_hcd_remove() call after=20
> dwc2_debugfs_exit(hsotg) and submit as patch:
>
> +error_debugfs:
> +	dwc2_debugfs_exit(hsotg);
> +	if (hsotg->hcd_enabled)
> +		dwc2_hcd_remove(hsotg);
>    error_init:

looks like it should be a separate patch though. Right?

=2D-=20
balbi

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEElLzh7wn96CXwjh2IzL64meEamQYFAl8ZirAACgkQzL64meEa
mQZQyBAAimttABmkTUf86JY2PCKMEFEnH584bnAZoAFs91mjC+hr5OKZA9EJWYx5
YJpw8OYHCfoydCEuDllipCcsb4WFrvqU6CaY9VeCuKdpzLzfbiZGQGzWuWS6j+5N
qBx/TXVMWZB7xe1flZJtM8w8/G/o2wot24rzZKU8x0nHggWzl/s53CsK/9q5XASb
ljqZVGbUTbDfG89c0EIr9XpV89qwYbiJZWRR0Ei5Q3dHJnzMytGtWEZv3yhXlirS
hm4gO9m1SiDT04nYr9gcXJvzFjaucAD88frXEY0wNlFIagv3TWoERnw6gI3DnHqj
sKqcuI8sKsk/ZkIfoKnF6tdWELXT3YXhat79cxbPpxC4w6UkNoV62o2xz4OYGgrg
VZfubNaQVcFIJBeV1hpcKu7Z1REd3qdujtwFg/vG4qEwD1KXHs/zqfA7akUV75wf
QjD4S8O4sVUFMLsZGjt9Wgme3MCIak5T3EjiRhGjMI2cboYbbbvEarYhJTlcAARM
9jBHXWvIyXtsl0sTS/z+kCiz0DFLY3V8Ny9eR/U0ES/vpKZXsKidsC8udfjebvuH
voDAied98JbvS8Nnby/+JXEKA8ecZF7QywQGTXbzFIIjOk4YV6dieINVsezy7KIM
ath5HSKuqkV7igte2NG3n2ZcJJ7cCROlbS/7w1leg5J9c/8i0dY=
=GxaY
-----END PGP SIGNATURE-----
--=-=-=--
