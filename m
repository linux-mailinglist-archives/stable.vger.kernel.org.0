Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 41E1114628A
	for <lists+stable@lfdr.de>; Thu, 23 Jan 2020 08:24:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725990AbgAWHYz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Jan 2020 02:24:55 -0500
Received: from mail-lj1-f196.google.com ([209.85.208.196]:44652 "EHLO
        mail-lj1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725785AbgAWHYz (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 Jan 2020 02:24:55 -0500
Received: by mail-lj1-f196.google.com with SMTP id q8so2035087ljj.11;
        Wed, 22 Jan 2020 23:24:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:in-reply-to:references:date:message-id
         :mime-version;
        bh=PO+/EdtxmoIB337Uw05Y/8H8Ge6zwOpflVL5MWt26PY=;
        b=G0fds4rIEiyIfLJHqvfVgDDOj1X4PQddS9IFWnrCIb0JSNo2SbYipZrqG2y8oayiuC
         VOMgzOa/youe9ap0jgRM7ap3JaJCY2b1/xVKK6rziVZefT70k97pLulMPTsr+pxetOxC
         sI+CnbNaaq2hIDw2bd1GK0CtzXb5kFXcugEOBNBXd7Cgv/dPMJQfoV4DFUSJpWDjIoGp
         zDQs9P3rd3hd8ATvzMzskQuce0OPDMzoy14O0p/njhv8canVsfVxhWQrJ1ytX7uPwwVe
         YRg8nwLa09rR6J+r3/98FJs295/Tftbq0zy/CIyGrdP68gZ5MovXWV55Lgr5kmiHmWtx
         ESMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:in-reply-to:references
         :date:message-id:mime-version;
        bh=PO+/EdtxmoIB337Uw05Y/8H8Ge6zwOpflVL5MWt26PY=;
        b=qu7K58e1L4YJNFx2Q7EzAvBBUWvLwdIU2CQMGjdnC4wUbdKolQAPBx1fsCJYWLkBtm
         YO6wJFuZEvyW+ByUll9oYjYQ/xdcylzfUcV+5aYRMrqDQ6qUgSaMDaJ0dCpVTWOZEXQ/
         yulW2QZvP0rDYvTM45UlBknrQ8XAwNn46u6Ateio1onqcj2tyUHTgEdjNvj1dYCtifdT
         ULm75Gx35915Bk2pSVv6ZiVETYcjoSlwhGOe/ezFrOXVDNVJHEj1u4Ad6aevkFv/Z5jY
         VQRcg6+U6S7yTeN2J5SAlccPIjcpG5mMkb0AUgmuw3dlrd9hHp2h+dcKfH8qtqz2qC3i
         MPHA==
X-Gm-Message-State: APjAAAUgRxGJSOLPAi8VtTCRDfNjnfaYpn6GBndU4yar4E7a+zXGMr9l
        sa1JGciHWGCkazuYF2EWSoI=
X-Google-Smtp-Source: APXvYqyL5kKScDlEz+0IBCoUuFQTzXQhJEUjdjWCkW35DBPBwbvEvZfdfDleC0OjDRAiD9xYmfmn4g==
X-Received: by 2002:a2e:880c:: with SMTP id x12mr22004208ljh.44.1579764291777;
        Wed, 22 Jan 2020 23:24:51 -0800 (PST)
Received: from saruman (88-113-215-33.elisa-laajakaista.fi. [88.113.215.33])
        by smtp.gmail.com with ESMTPSA id m15sm620655ljg.4.2020.01.22.23.24.50
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 22 Jan 2020 23:24:50 -0800 (PST)
From:   Felipe Balbi <balbi@kernel.org>
To:     John Stultz <john.stultz@linaro.org>,
        lkml <linux-kernel@vger.kernel.org>
Cc:     Anurag Kumar Vulisha <anurag.kumar.vulisha@xilinx.com>,
        Felipe Balbi <felipe.balbi@linux.intel.com>,
        Yang Fei <fei.yang@intel.com>,
        Thinh Nguyen <thinhn@synopsys.com>,
        Tejas Joglekar <tejas.joglekar@synopsys.com>,
        Andrzej Pietrasiewicz <andrzej.p@collabora.com>,
        Jack Pham <jackp@codeaurora.org>, Todd Kjos <tkjos@google.com>,
        Greg KH <gregkh@linuxfoundation.org>,
        Linux USB List <linux-usb@vger.kernel.org>,
        stable <stable@vger.kernel.org>,
        John Stultz <john.stultz@linaro.org>
Subject: Re: [RFC][PATCH 2/2] usb: dwc3: gadget: Correct the logic for finding last SG entry
In-Reply-To: <20200122222645.38805-3-john.stultz@linaro.org>
References: <20200122222645.38805-1-john.stultz@linaro.org> <20200122222645.38805-3-john.stultz@linaro.org>
Date:   Thu, 23 Jan 2020 09:25:40 +0200
Message-ID: <87r1zq4osr.fsf@kernel.org>
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


Hi,

John Stultz <john.stultz@linaro.org> writes:
> From: Anurag Kumar Vulisha <anurag.kumar.vulisha@xilinx.com>
>
> As a process of preparing TRBs usb_gadget_map_request_by_dev() is
> called from dwc3_prepare_trbs() for mapping the request. This will
> call dma_map_sg() if req->num_sgs are greater than 0. dma_map_sg()
> will map the sg entries in sglist and return the number of mapped SGs.
> As a part of mapping, some sg entries having contigous memory may be
> merged together into a single sg (when IOMMU used). So, the number of
> mapped sg entries may not be equal to the number of orginal sg entries
> in the request (req->num_sgs).
>
> As a part of preparing the TRBs, dwc3_prepare_one_trb_sg() iterates over
> the sg entries present in the sglist and calls sg_is_last() to identify
> whether the sg entry is last and set IOC bit for the last sg entry. The
> sg_is_last() determines last sg if SG_END is set in sg->page_link. When
> IOMMU used, dma_map_sg() merges 2 or more sgs into a single sg and it
> doesn't retain the page_link properties. Because of this reason the
> sg_is_last() may not find SG_END and thus resulting in IOC bit never
> getting set.
>
> For example:
>
> Consider a request having 8 sg entries with each entry having a length of
> 4096 bytes. Assume that sg1 & sg2, sg3 & sg4, sg5 & sg6, sg7 & sg8 are
> having contigous memory regions.
>
> Before calling dma_map_sg():
>             sg1-->sg2-->sg3-->sg4-->sg6-->sg7-->sg8
> dma_length: 4K    4K    4K    4K    4K    4K    4K
> SG_END:     False False False False False False True
> num_sgs =3D 8
> num_mapped_sgs =3D 0
>
> The dma_map_sg() merges sg1 & sg2 memory regions into sg1->dma_address.
> Similarly sg3 & sg4 into sg2->dma_address, sg5 & sg6 into the
> sg3->dma_address and sg6 & sg8 into sg4->dma_address. Here the memory
> regions are merged but the page_link properties like SG_END are not
> retained into the merged sgs.
>
> After calling dma_map_sg();
>             sg1-->sg2-->sg3-->sg4-->sg6-->sg7-->sg8
> dma_length: 8K    8K    8K    8K    0K    0K     0K
> SG_END:     False False False False False False True
> num_sgs =3D 8
> num_mapped_sgs =3D 4
>
> After calling dma_map_sg(), sg1,sg2,sg3,sg4 are having dma_length of
> 8096 bytes each and remaining sg4,sg5,sg6,sg7 are having 0 bytes of
> dma_length.
>
> After dma_map_sg() is performed dma_perpare_trb_sg() iterates on all sg
> entries and sets IOC bit only for the sg8 (since sg_is_last() returns true
> only for sg8). But after calling dma_map_sg() the valid data are present
> only till sg4 and the IOC bit should be set for sg4 TRB only (which is not
> happening in the present code)
>
> The above mentioned issue can be fixed by determining last sg based on the
> req->num_queued_sgs instead of sg_is_last(). If (req->num_queued_sgs + 1)
> is equal to req->num_mapped_sgs, then this sg is the last sg. In the above
> example, the dwc3 driver has already queued 3 sgs (upto sg3), so the
> num_queued_sgs =3D 3. On preparing the next sg (i.e sg4), check for last =
sg
> (num_queued_sgs + 1) =3D=3D num_mapped_sgs becomes true. So, the driver s=
ets
> IOC bit for sg4. This patch does the same.
>
> At a practical level, this patch resolves USB transfer stalls
> seen with adb on dwc3 based db845c, pixel3 and other qcom
> hardware after functionfs gadget added scatter-gather support
> around v4.20.
>
> Cc: Felipe Balbi <felipe.balbi@linux.intel.com>
> Cc: Yang Fei <fei.yang@intel.com>
> Cc: Thinh Nguyen <thinhn@synopsys.com>
> Cc: Tejas Joglekar <tejas.joglekar@synopsys.com>
> Cc: Andrzej Pietrasiewicz <andrzej.p@collabora.com>
> Cc: Jack Pham <jackp@codeaurora.org>
> Cc: Todd Kjos <tkjos@google.com>
> Cc: Greg KH <gregkh@linuxfoundation.org>
> Cc: Linux USB List <linux-usb@vger.kernel.org>
> Cc: stable <stable@vger.kernel.org>
> Signed-off-by: Anurag Kumar Vulisha <anurag.kumar.vulisha@xilinx.com>
> [jstultz: Add note to end of commit message on specific issue this resovl=
es]
> Signed-off-by: John Stultz <john.stultz@linaro.org>
> ---
>  drivers/usb/dwc3/gadget.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/usb/dwc3/gadget.c b/drivers/usb/dwc3/gadget.c
> index 1edce3bbb55c..30a80bc97cfe 100644
> --- a/drivers/usb/dwc3/gadget.c
> +++ b/drivers/usb/dwc3/gadget.c
> @@ -1068,7 +1068,7 @@ static void dwc3_prepare_one_trb_sg(struct dwc3_ep =
*dep,
>  		unsigned int rem =3D length % maxp;
>  		unsigned chain =3D true;
>=20=20
> -		if (sg_is_last(s))
> +		if ((req->num_queued_sgs + 1) =3D=3D req->request.num_mapped_sgs)

This is probably a bug on DMA API. If it combines pages from
scatter-list, then it should also move the last SG so sg_is_last()
continues to work.

I had asked author to discuss this with DMA API maintainers. Can you do
that?

=2D-=20
balbi

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEElLzh7wn96CXwjh2IzL64meEamQYFAl4pSnQACgkQzL64meEa
mQb7Yg/+PnSb51d1HUUeuHT8QUblsTEKU68Qb06aygcf99oZctcC0jsnQvaaPTTq
ceDuG2AOT7IL4OMBOUibjUUYy1HS0194D9Zrq1/xUqu6DcIo3ZgDb2QVUX27jOuX
qRYyag5uj5mmOpJSCHOC6X71wLPU/CMPBlDTK27+Ogtqtke2jiFnLz8bZoW8rZKM
7xxZ0t892oR5Qr/kqdJrDQUDvfjXiRl0hjzudywE0HwH77uxALFjYi8UAZ868qv3
MERgNMIGV35UZZDSs5fhTQp79YUgJjmDfiZblUhr3vphDQsuzykYXKJ3ZWYtvXHz
XOEUTTc0dVRbtYoKEZh3727Grv4nVqZ+IqzmI7uZQtTNr38DB5X9b/psWPm7nZS/
MlIYUpfeIBXXW5XwLG6f1JZ+K33sTfjVeTyrHs8/2V+BOGoVnuXBMjKEoSAlEI6K
NOxZvJVfUOG+gemezrgMCb7TJFCTVjCI1v7qwbWRiYsy+SNezs05iv+H69JysYiG
oqybEgcHV7jGijr3myV51Rr+oWadqTjVYO7nntyJjtXJENf+/ULWzZsL1pauihtJ
Fz8xrFNhwGYuUnvgbSUExBY7F1CY86C66chY9HpBKFXywbOSL8yoOflTrGKasq1X
VkGbxKq4vRIdN9Enii/VaTyFlG+tXV4glH3YZlbTG75uU8ckEmg=
=j5rc
-----END PGP SIGNATURE-----
--=-=-=--
