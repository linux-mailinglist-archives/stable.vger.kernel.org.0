Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6C31B15523A
	for <lists+stable@lfdr.de>; Fri,  7 Feb 2020 07:00:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726586AbgBGGAd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 7 Feb 2020 01:00:33 -0500
Received: from mail-lj1-f194.google.com ([209.85.208.194]:35758 "EHLO
        mail-lj1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726451AbgBGGAd (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 7 Feb 2020 01:00:33 -0500
Received: by mail-lj1-f194.google.com with SMTP id q8so828509ljb.2;
        Thu, 06 Feb 2020 22:00:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:in-reply-to:references:date:message-id
         :mime-version;
        bh=sq6ybjOayYcalJ4lzNuN0BfbMV5nTTAFHYcjyZ14Als=;
        b=nAnbHX39PNKnEKgMWUDjc6hFGYj2b0UIgK5opMO0Lu9n/v2dGbp6d/ig+nrljInYU/
         thwgcwxJy0wmT9xVnSsg0+hOtqG72xIfH7yb98v0eeryBFsQylP6uYLBWZeEF8adgmbd
         6G1zl05a2C9qjCcEcECKdZSDgG4RkjazsUaQ3Gg6Wp7oBLR4nIlv6bcPxoAaoekBR9Ow
         vniUUe/thYYklMmHdKQ2nL2UQUC+9jDsIhWT11k1qPvZhZKQy+31gaPNz3NmIT+m6uAf
         B/vZTFLmSaSB2POD6xNnjDT2l5PuWysAuUD1//r8ItESYxVr2f1QXnD+qDb5lt7ItncS
         tbyQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:in-reply-to:references
         :date:message-id:mime-version;
        bh=sq6ybjOayYcalJ4lzNuN0BfbMV5nTTAFHYcjyZ14Als=;
        b=CGMjAhB4Z8sMQTRxZBRR1ZJJZ3NINGMytENOa3tiuAWK6gQZ0kNnKa6SgyGqBadDrU
         M+bvWLoD6/75JBlA1kAbrBLNCO+1HzE2sc6mMHBvYM+w7gXuCVKIjUVDZU9wOXCZXdFV
         UEtNRAUyJw4i/a63Jht3Pnlra7cCOHeeTCH+Do7oseY8ThHC7DXsHJYKc836TuuGostH
         UuMTxmsSBuphwRQoN5IUnvb2RzSrbPGh8kinMUsUUvQZWrJjcL4EJV7NvazUwHYV1BJ+
         BORBBLnk9JvzNWO/DZT/2ytLuOan5qCl/vcs3AcdPkG9gmtixJvl1Tlpxf0+5B4Teu2W
         0drQ==
X-Gm-Message-State: APjAAAV7wUk7070ZZ3uNg3GXgOeP+ZjzvuCgAlwok7Ug1VsBBcXU0x6R
        EfYdo9GQthqptankK2t/0Qo=
X-Google-Smtp-Source: APXvYqyy+vYcfoS9iJ2m4VhQw7K5CDSM0/DlXqjP+tgubs12kqT1Si38b/1JK2s0PRZMC591NPsWEw==
X-Received: by 2002:a2e:9e55:: with SMTP id g21mr4320411ljk.245.1581055229182;
        Thu, 06 Feb 2020 22:00:29 -0800 (PST)
Received: from saruman (88-113-215-33.elisa-laajakaista.fi. [88.113.215.33])
        by smtp.gmail.com with ESMTPSA id w16sm580411lfc.1.2020.02.06.22.00.27
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 06 Feb 2020 22:00:28 -0800 (PST)
From:   Felipe Balbi <balbi@kernel.org>
To:     Christoph Hellwig <hch@infradead.org>
Cc:     Christoph Hellwig <hch@infradead.org>,
        John Stultz <john.stultz@linaro.org>,
        "Yang\, Fei" <fei.yang@intel.com>,
        Andrzej Pietrasiewicz <andrzej.p@collabora.com>,
        lkml <linux-kernel@vger.kernel.org>,
        Felipe Balbi <felipe.balbi@linux.intel.com>,
        Thinh Nguyen <thinhn@synopsys.com>,
        Tejas Joglekar <tejas.joglekar@synopsys.com>,
        Jack Pham <jackp@codeaurora.org>, Todd Kjos <tkjos@google.com>,
        Greg KH <gregkh@linuxfoundation.org>,
        Linux USB List <linux-usb@vger.kernel.org>,
        stable <stable@vger.kernel.org>, Jens Axboe <axboe@kernel.dk>
Subject: Re: [RFC][PATCH 0/2] Avoiding DWC3 transfer stalls/hangs when using adb over f_fs
In-Reply-To: <20200206184134.GA11027@infradead.org>
References: <20200122222645.38805-1-john.stultz@linaro.org> <ef64036f-7621-50d9-0e23-0f7141a40d7a@collabora.com> <02E7334B1630744CBDC55DA8586225837F9EE280@ORSMSX102.amr.corp.intel.com> <87o8uu3wqd.fsf@kernel.org> <02E7334B1630744CBDC55DA8586225837F9EE335@ORSMSX102.amr.corp.intel.com> <87lfpy3w1g.fsf@kernel.org> <CALAqxLUQ0ciJTLrmEAu9WKCJHAbpY9szuVm=+VapN2QWWGnNjA@mail.gmail.com> <20200206074005.GA28365@infradead.org> <87ftfn602u.fsf@kernel.org> <20200206184134.GA11027@infradead.org>
Date:   Fri, 07 Feb 2020 08:00:14 +0200
Message-ID: <874kw35441.fsf@kernel.org>
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

Christoph Hellwig <hch@infradead.org> writes:
> On Thu, Feb 06, 2020 at 08:29:45PM +0200, Felipe Balbi wrote:
>> Fair enough. Just out of curiosity, then, when *should* we use
>> sg_is_last()?
>
> Outside of sg_next/sg_last it really shoud not be used at all as far
> as I'm concerned.

In that case, we may have other drivers with similar issues that just
haven't surfaced:

$ git --no-pager grep -e sg_is_last
drivers/ata/pata_octeon_cf.c:701:			if (!sg_is_last(qc->cursg)) {
drivers/crypto/amcc/crypto4xx_core.c:738:	if (sg_is_last(dst) && force_sd =
=3D=3D false) {
drivers/crypto/atmel-sha.c:318:			if ((ctx->sg->length =3D=3D 0) && !sg_is_=
last(ctx->sg)) {
drivers/crypto/atmel-sha.c:781:	if (!sg_is_last(sg) && !IS_ALIGNED(sg->leng=
th, ctx->block_size))
drivers/crypto/atmel-sha.c:787:	if (sg_is_last(sg)) {
drivers/crypto/ccree/cc_buffer_mgr.c:293:	if (sg_is_last(sg)) {
drivers/crypto/ccree/cc_buffer_mgr.c:305:	} else {  /*sg_is_last*/
drivers/crypto/hisilicon/hpre/hpre_crypto.c:238:	if ((sg_is_last(data) && l=
en =3D=3D ctx->key_sz) &&
drivers/crypto/marvell/tdma.c:25:		if (sg_is_last(sgiter->sg))
drivers/crypto/mediatek/mtk-sha.c:196:			if ((ctx->sg->length =3D=3D 0) && =
!sg_is_last(ctx->sg)) {
drivers/crypto/mediatek/mtk-sha.c:530:	if (!sg_is_last(sg) && !IS_ALIGNED(s=
g->length, ctx->bs))
drivers/crypto/mediatek/mtk-sha.c:536:	if (sg_is_last(sg)) {
drivers/crypto/mxs-dcp.c:339:			if (actx->fill =3D=3D out_off || sg_is_last=
(src) ||
drivers/crypto/qat/qat_common/qat_asym_algs.c:322:		if (sg_is_last(req->src=
) && req->src_len =3D=3D ctx->p_size) {
drivers/crypto/qat/qat_common/qat_asym_algs.c:353:	if (sg_is_last(req->dst)=
 && req->dst_len =3D=3D ctx->p_size) {
drivers/crypto/qat/qat_common/qat_asym_algs.c:730:	if (sg_is_last(req->src)=
 && req->src_len =3D=3D ctx->key_sz) {
drivers/crypto/qat/qat_common/qat_asym_algs.c:749:	if (sg_is_last(req->dst)=
 && req->dst_len =3D=3D ctx->key_sz) {
drivers/crypto/qat/qat_common/qat_asym_algs.c:874:	if (sg_is_last(req->src)=
 && req->src_len =3D=3D ctx->key_sz) {
drivers/crypto/qat/qat_common/qat_asym_algs.c:893:	if (sg_is_last(req->dst)=
 && req->dst_len =3D=3D ctx->key_sz) {
drivers/crypto/rockchip/rk3288_crypto_ahash.c:238:			if (sg_is_last(dev->sg=
_src)) {
drivers/crypto/rockchip/rk3288_crypto_skcipher.c:356:			if (sg_is_last(dev-=
>sg_src)) {
drivers/crypto/s5p-sss.c:581:	if (!sg_is_last(dev->sg_dst)) {
drivers/crypto/s5p-sss.c:603:	if (!sg_is_last(dev->sg_src)) {
drivers/crypto/s5p-sss.c:690:		if (sg_is_last(dev->sg_dst))
drivers/crypto/stm32/stm32-hash.c:304:			if ((rctx->sg->length =3D=3D 0) &&=
 !sg_is_last(rctx->sg)) {
drivers/crypto/stm32/stm32-hash.c:568:		if (sg_is_last(sg)) {
drivers/crypto/stm32/stm32-hash.c:595:					  !sg_is_last(sg));
drivers/crypto/stm32/stm32-hash.c:668:			    (!sg_is_last(sg)))
drivers/dma/ipu/ipu_idmac.c:847:		dma_addr_t dma_1 =3D sg_is_last(desc->sg)=
 ? 0 :
drivers/gpu/drm/i915/i915_gpu_error.c:649:			if (sg_is_last(sg))
drivers/gpu/drm/i915/i915_gpu_error.c:653:		sg =3D sg_is_last(sg) ? NULL : =
sg_chain_ptr(sg);
drivers/gpu/drm/i915/i915_gpu_error.c:903:	} while (!sg_is_last(sg++));
drivers/gpu/drm/i915/i915_scatterlist.h:66:	return sg_is_last(sg) ? NULL : =
____sg_next(sg);
drivers/hwtracing/intel_th/msu.c:545:	if (sg_is_last(iter->block))
drivers/memstick/core/ms_block.c:43:			if (sg_is_last(sg_from))
drivers/memstick/core/ms_block.c:58:		if (sg_is_last(sg_from) || !len)
drivers/memstick/core/ms_block.c:73:		if (sg_is_last(sg_from) || !len)
drivers/mmc/host/bcm2835.c:485:			if (sg_is_last(sg)) {
drivers/rapidio/devices/tsi721_dma.c:514:		if (sg_is_last(sg)) {
drivers/s390/scsi/zfcp_qdio.h:184:	return sg_is_last(sg) && sg->length <=3D=
 ZFCP_QDIO_SBALE_LEN;
drivers/scsi/NCR5380.c:171:	if (!cmd->SCp.this_residual && s && !sg_is_last=
(s)) {
drivers/scsi/NCR5380.c:184:		while (!sg_is_last(s)) {
drivers/scsi/aha152x.c:2019:				    !sg_is_last(CURRENT_SC->SCp.buffer)) {
drivers/scsi/aha152x.c:2125:		    !sg_is_last(CURRENT_SC->SCp.buffer)) {
drivers/scsi/aha152x.c:2155:		while (done > 0 && !sg_is_last(sg)) {
drivers/scsi/qla2xxx/qla_iocb.c:1226:				    sg_is_last(sg)) {
drivers/spi/spi-bcm2835.c:484:	if (bs->tx_buf && !sg_is_last(&tfr->tx_sg.sg=
l[0]))
drivers/spi/spi-bcm2835.c:487:	if (bs->rx_buf && !sg_is_last(&tfr->rx_sg.sg=
l[0])) {
drivers/spi/spi-bcm2835.c:491:			if (!bs->tx_buf || sg_is_last(&tfr->tx_sg.=
sgl[0])) {
drivers/usb/dwc2/gadget.c:861:			sg_is_last(sg));
drivers/usb/dwc3/gadget.c:1074:		if (sg_is_last(s))
drivers/usb/image/microtek.c:507:			   sg_is_last(context->curr_sg) ?
include/linux/devcoredump.h:40:	while (!sg_is_last(iter)) {
include/linux/scatterlist.h:73:#define sg_is_last(sg)		((sg)->page_link & S=
G_END)
lib/scatterlist.c:25:	if (sg_is_last(sg))
lib/scatterlist.c:109:	BUG_ON(!sg_is_last(ret));
net/core/skbuff.c:4289:			if (unlikely(elt && sg_is_last(&sg[elt - 1])))
net/core/skbuff.c:4311:			if (unlikely(elt && sg_is_last(&sg[elt - 1])))
net/tls/tls_main.c:116:		if (sg_is_last(sg))
net/xfrm/espintcp.c:179:		if (sg_is_last(sg))
samples/kfifo/dma-example.c:79:		if (sg_is_last(&sg[i]))
samples/kfifo/dma-example.c:108:		if (sg_is_last(&sg[i]))
tools/virtio/linux/scatterlist.h:15:#define sg_is_last(sg)		((sg)->page_lin=
k & 0x02)
tools/virtio/linux/scatterlist.h:139:	if (sg_is_last(sg))

=2D-=20
balbi

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEElLzh7wn96CXwjh2IzL64meEamQYFAl48/PAACgkQzL64meEa
mQZKTw/8CATJzYXivz4DWZsn0WhMVwYDagEQYGL/Kd+BO0FMePDRteX4ZvdG2CCJ
RfK32cw/aCsWyzDCkVMByVyozb3puoTophZlu2LMU1spHwGGPQAvWwqrv0W9gM77
kvwbczm/DXc6Ffsb+Md5j0JcLrGQ9pHsbmcrSX0RGTls2jx5xQPUS/j0d7gctfr3
FT7L/hZ2JMSBqg/X86npwzBOC4HqCZ6ivfkkMAYCe7xihlMaWY5JGP/TpK/V/Z9f
FaO7JkRPkUI+VK5100WNiRXzhI0t3q1r9xYJTtfRlGRTtx2wBtECArE/hEBciqQv
5XxPW/mvNcfDXZVMXBG8Az+FlNVd+XnTBy+Vt32TESoxKF05OKpp3R/3RBCFszJM
GWPIsdUYYO08qzhSzndFqzA8DStCqTtMtUR4xfZIglPVosLpR/viejKFy86ypfsA
5RP66meFhpXFZLzA5U9qaL5bMBQRgrTYJAisYY/7o/FYWVAIt0Mkjqn53sYF7RuS
UzDvBE11xPbDxNKujuvZchBHQkxvfZDdTS3+xMIsARA8RsxuEa1WwDtriIuFIP+U
fAVW8Vj1pmRyOBSoqr1HBjirv62xTUKKpnEYePtlasQfUCD0yllEt1sFs9UveGXb
VytKId1P6xDkGYNof21aiZO5eCfaj5Y49yopHxJPbpNtxY31ybo=
=RBU9
-----END PGP SIGNATURE-----
--=-=-=--
