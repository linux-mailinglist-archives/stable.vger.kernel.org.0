Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5731B6B9E1C
	for <lists+stable@lfdr.de>; Tue, 14 Mar 2023 19:19:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229875AbjCNSTD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Mar 2023 14:19:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46060 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229888AbjCNSTB (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 14 Mar 2023 14:19:01 -0400
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 49DAF10A9E;
        Tue, 14 Mar 2023 11:18:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1678817910; x=1710353910;
  h=message-id:subject:from:to:cc:date:in-reply-to:
   references:content-transfer-encoding:mime-version;
  bh=EMNSMIc/1OLn4clLWf8xoaZ0++kSg/7KOnW5Rsc1hVo=;
  b=jzdt3cXUJtxQtetZGTLnZKHD7deDjn/gQDeAciZ24wWF4Yw8TRNFt1iu
   5Dr3bekP5X2LdMEJ3GaKplM//APrHDDGxY665IKwjNkNiowJMy4CIDIst
   BTPt2xjc/IlpKlGIl/js17AAZQgD23b5YUA99drzwwl4IetPZliSG8XPc
   6mBsGZLaDXrZ0SOaAhnTg9XV+q60i9ZG37d1HUr5vuesHazK6Dnvw8tAi
   7qR8ks0odgRf/NdHhFixJRq7GGcnlDKMkbFGY2BzmWAn3HIZV6/EBlAvQ
   9wt/SmSfWgUYTbdJw/GgxjmJBUGTLZby/y4bUrkK0BgWB4SkfJ+BlK0T1
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10649"; a="317904475"
X-IronPort-AV: E=Sophos;i="5.98,260,1673942400"; 
   d="scan'208";a="317904475"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Mar 2023 11:18:29 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10649"; a="672433830"
X-IronPort-AV: E=Sophos;i="5.98,260,1673942400"; 
   d="scan'208";a="672433830"
Received: from chenjona-mobl.amr.corp.intel.com ([10.209.88.170])
  by orsmga007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Mar 2023 11:18:28 -0700
Message-ID: <8fc761f7c432a4936505cb62a6db101e9cc6c824.camel@linux.intel.com>
Subject: Re: [PATCH v4] HID:hid-sensor-custom: Fix buffer overrun in device
 name
From:   srinivas pandruvada <srinivas.pandruvada@linux.intel.com>
To:     Todd Brandt <todd.e.brandt@intel.com>, linux-input@vger.kernel.org,
        linux-iio@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     todd.e.brandt@linux.intel.com, jic23@kernel.org, jikos@kernel.org,
        p.jungkamp@gmx.net, stable@vger.kernel.org
Date:   Tue, 14 Mar 2023 11:18:27 -0700
In-Reply-To: <20230314181256.15283-1-todd.e.brandt@intel.com>
References: <20230314181256.15283-1-todd.e.brandt@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.44.4-0ubuntu1 
MIME-Version: 1.0
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, 2023-03-14 at 11:12 -0700, Todd Brandt wrote:
> On some platforms there are some platform devices created with
> invalid names. For example: "HID-SENSOR-INT-020b?.39.auto" instead
> of "HID-SENSOR-INT-020b.39.auto"
>=20
> This string include some invalid characters, hence it will fail to
> properly load the driver which will handle this custom sensor. Also
> it is a problem for some user space tools, which parses the device
> names from ftrace and dmesg.
>=20
> This is because the string, real_usage, is not NULL terminated and
> printed with %s to form device name.
>=20
> To address this, initialize the real_usage string with 0s.
>=20
> Reported-and-tested-by: Todd Brandt <todd.e.brandt@linux.intel.com>
> Link: https://bugzilla.kernel.org/show_bug.cgi?id=3D217169
> Fixes: 98c062e82451 ("HID: hid-sensor-custom: Allow more custom iio
> sensors")
> Cc: stable@vger.kernel.org
> Suggested-by: Philipp Jungkamp <p.jungkamp@gmx.net>
> Signed-off-by: Philipp Jungkamp <p.jungkamp@gmx.net>
> Signed-off-by: Todd Brandt <todd.e.brandt@intel.com>
> Reviewed-by: Andi Shyti <andi.shyti@kernel.org>
> Reviewed-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Acked-by: Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>

> ---
> Changes in v4:
> - add the Fixes line
> - add patch version change list
> Changes in v3:
> - update the changelog
> - add proper reviewed/signed/suggested links
> Changes in v2:
> - update the changelog
>=20
> =C2=A0drivers/hid/hid-sensor-custom.c | 2 +-
> =C2=A01 file changed, 1 insertion(+), 1 deletion(-)
>=20
> diff --git a/drivers/hid/hid-sensor-custom.c b/drivers/hid/hid-
> sensor-custom.c
> index 3e3f89e01d81..d85398721659 100644
> --- a/drivers/hid/hid-sensor-custom.c
> +++ b/drivers/hid/hid-sensor-custom.c
> @@ -940,7 +940,7 @@ hid_sensor_register_platform_device(struct
> platform_device *pdev,
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 struct hid_=
sensor_hub_device
> *hsdev,
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 const struc=
t
> hid_sensor_custom_match *match)
> =C2=A0{
> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0char real_usage[HID_SENSOR_USA=
GE_LENGTH];
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0char real_usage[HID_SENSOR_USA=
GE_LENGTH] =3D { 0 };
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0struct platform_device *c=
ustom_pdev;
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0const char *dev_name;
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0char *c;

