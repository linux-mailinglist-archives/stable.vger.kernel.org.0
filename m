Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 557845EDE65
	for <lists+stable@lfdr.de>; Wed, 28 Sep 2022 16:05:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233405AbiI1OFo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Sep 2022 10:05:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53826 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232196AbiI1OFn (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Sep 2022 10:05:43 -0400
Received: from comms.puri.sm (comms.puri.sm [159.203.221.185])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9457A4621A;
        Wed, 28 Sep 2022 07:05:41 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
        by comms.puri.sm (Postfix) with ESMTP id 241CFDFCC4;
        Wed, 28 Sep 2022 07:05:11 -0700 (PDT)
Received: from comms.puri.sm ([127.0.0.1])
        by localhost (comms.puri.sm [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id q9mgVAepVsLG; Wed, 28 Sep 2022 07:05:09 -0700 (PDT)
From:   Sebastian Krzyszkowiak <sebastian.krzyszkowiak@puri.sm>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=puri.sm; s=comms;
        t=1664373909; bh=ZKO+i8RWhWw2AHZpNTgjawEvl9gmMGjIlZD9ogtlUQY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kB89csYEMorp0B712OdIFJNS2kgD/w79YYLEidyX6cLOwcdx4Amn3ZADkOIa6EFBQ
         hbt3JZr2RlPwMHc2q9le0nkyE3VWWe5QP7u/gLTxZ4sbYX89ZdcFgOCPZCX7Rm9Xqm
         RRTyWGCkoMq8ybHKyjCdX5Xs1sdBjqHNzFtgXfRiyN+Djj/X+IHRj1p9nvWqlmchFi
         2uFP1Px6DULmirq24HmUZ2xYPtko90UMJ41UtgAl4MPmQZpIGH2HzNnWz2wvqcyWZG
         Er+n1LD1JY+u+HoaCaAhWVKI9luSS6B74i05elf/7D/A876x4QvBTsu0iAmO/0C4jn
         tvUuoUgjR4djg==
To:     "Rafael J. Wysocki" <rafael@kernel.org>, linux-pm@vger.kernel.org,
        Daniel Lezcano <daniel.lezcano@linaro.org>
Cc:     Amit Kucheria <amitk@kernel.org>, Zhang Rui <rui.zhang@intel.com>,
        Andrey Smirnov <andrew.smirnov@gmail.com>,
        linux-kernel@vger.kernel.org, kernel@puri.sm,
        stable@vger.kernel.org
Subject: Re: [PATCH v3 RESEND] thermal: qoriq: Only enable sites that actually exist
Date:   Wed, 28 Sep 2022 16:05:03 +0200
Message-ID: <5800115.iIbC2pHGDl@pliszka>
In-Reply-To: <bf7ab516-3d18-6a5a-95f2-71f918b54cf1@linaro.org>
References: <7115709.31r3eYUQgx@pliszka> <bf7ab516-3d18-6a5a-95f2-71f918b54cf1@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On wtorek, 27 wrze=C5=9Bnia 2022 10:34:00 CEST Daniel Lezcano wrote:
> Hi Sebastian,
>=20
> On 27/09/2022 08:15, Sebastian Krzyszkowiak wrote:
> > On i.MX8MQ, enabling monitoring sites that aren't connected to anything
> > can cause unwanted side effects on some units. This seems to happen
> > once some of these sites report out-of-range readings and results in
> > sensor misbehavior, such as thermal zone readings getting stuck or even
> > suddenly reporting an impossibly high value, triggering emergency
> > shutdowns.
> >=20
> > The datasheet lists all non-existent sites as "reserved" and doesn't
> > make any guarantees about being able to enable them at all, so let's
> > not do that. Instead, iterate over sensor DT nodes and only enable
> > monitoring sites that are specified there prior to registering their
> > thermal zones. This still fixes the issue with bogus data being
> > reported on the first reading, but doesn't introduce problems that
> > come with reading from non-existent sites.
>=20
> Can you have a look at these patches:
>=20
> https://git.kernel.org/pub/scm/linux/kernel/git/thermal/linux.git/commit/=
?h=3D
> thermal/linux-next&id=3Dab2266ecaa3254811f9f83992cf53fdfe3c62c86
>=20
> and
>=20
> https://git.kernel.org/pub/scm/linux/kernel/git/thermal/linux.git/commit/=
?h=3D
> thermal/linux-next&id=3D7be4288625df54887b444991d743c6e1af21e27a
>=20
> Thanks
>    -- Daniel


Hi Daniel,

I'm not sure if that's a good idea. qoriq-thermal has used=20
thermal_zone_of_get_sensor_id up until 45038e03d633, which was a change mea=
nt=20
to fix a bug with bogus data being present on the first report (as zones we=
re=20
being registered before their monitoring was being enabled), but it was don=
e=20
is a problematic way that introduced erratic behavior. The only ways to fix=
=20
this regression that I see are either to make the driver aware of which zon=
es=20
are present on particular platform (like my patch does by using=20
thermal_zone_of_get_sensor_id again), or to have some way to attempt=20
registering a thermal zone that isn't necessarily ready to report data yet.

Looking at device trees where qoriq-thermal is used, it seems like zone=20
configuration is pretty diverse across SoCs:

arm/ls1021a.dtsi: 0 cpu_thermal
arm64/fsl-ls1012a.dtsi: 0 cpu_thermal
arm64/fsl-ls1028a.dtsi: 0 ddr_controller 1 core_cluster
arm64/fsl-ls1043a.dtsi: 0 ddr_controller 1 serdes 2 fman 3 core-cluster 4 s=
ec
arm64/fsl-ls1046a.dtsi: 0 ddr_controller 1 serdes 2 fman 3 core-cluster 4 s=
ec
arm64/fsl-ls1088a.dtsi: 0 core-cluser 1 soc
arm64/fsl-ls208xa.dtsi: 1 ddr-controller1 2 ddr-controller2 3 ddr-controlle=
r3=20
4 core-cluster1 5 core-cluster2 6 core-cluster3 7 core-cluster4
arm64/fsl-lx2160a.dtsi: 0 cluster6-7 1 ddr-cluster5 2 wriop 3 dce-qbman-hsi=
o2=20
4 ccn-dpaa-tbu 5 cluster4-hsio3 6 cluster2-3
arm64/imx8mq.dtsi: 0 cpu-thermal 1 gpu-thermal 2 vpu-thermal
powerpc/t1023si-post.dtsi: 0 cpu_thermal
powerpc/t1040si-post.dtsi: 2 cpu_thermal

I haven't checked dts files where those get included, but I believe it's ra=
ther=20
unlikely that any additional zones are defined there.

Do you mean that this should all go as platform data into the driver? If so=
,=20
should all the calibration data that's currently in device trees go there a=
s=20
well? (if not, why not?)

Cheers,
Sebastian

> > Fixes: 45038e03d633 ("thermal: qoriq: Enable all sensors before
> > registering them") Cc: stable@vger.kernel.org
> > Signed-off-by: Sebastian Krzyszkowiak <sebastian.krzyszkowiak@puri.sm>
> > ---
> > Resent <20220321170852.654094-1-sebastian.krzyszkowiak@puri.sm>
> > v3: add cc: stable
> > v2: augment the commit message with details on what the patch is doing
> > ---
> >=20
> >   drivers/thermal/qoriq_thermal.c | 63 ++++++++++++++++++++++-----------
> >   1 file changed, 43 insertions(+), 20 deletions(-)
> >=20
> > diff --git a/drivers/thermal/qoriq_thermal.c
> > b/drivers/thermal/qoriq_thermal.c index 73049f9bea25..ef0848849ee2 1006=
44
> > --- a/drivers/thermal/qoriq_thermal.c
> > +++ b/drivers/thermal/qoriq_thermal.c
> > @@ -32,7 +32,6 @@
> >=20
> >   #define TMR_DISABLE	0x0
> >   #define TMR_ME		0x80000000
> >   #define TMR_ALPF	0x0c000000
> >=20
> > -#define TMR_MSITE_ALL	GENMASK(15, 0)
> >=20
> >   #define REGS_TMTMIR	0x008	/* Temperature measurement interval=20
Register
> >   */
> >   #define TMTMIR_DEFAULT	0x0000000f
> >=20
> > @@ -129,33 +128,51 @@ static const struct thermal_zone_of_device_ops
> > tmu_tz_ops =3D {>=20
> >   static int qoriq_tmu_register_tmu_zone(struct device *dev,
> >  =20
> >   				       struct qoriq_tmu_data=20
*qdata)
> >  =20
> >   {
> >=20
> > -	int id;
> > +	int ret =3D 0;
> > +	struct device_node *np, *child, *sensor_np;
> >=20
> > -	if (qdata->ver =3D=3D TMU_VER1) {
> > -		regmap_write(qdata->regmap, REGS_TMR,
> > -			     TMR_MSITE_ALL | TMR_ME | TMR_ALPF);
> > -	} else {
> > -		regmap_write(qdata->regmap, REGS_V2_TMSR,=20
TMR_MSITE_ALL);
> > -		regmap_write(qdata->regmap, REGS_TMR, TMR_ME |=20
TMR_ALPF_V2);
> > -	}
> > +	np =3D of_find_node_by_name(NULL, "thermal-zones");
> > +	if (!np)
> > +		return -ENODEV;
> > +
> > +	sensor_np =3D of_node_get(dev->of_node);
> >=20
> > -	for (id =3D 0; id < SITES_MAX; id++) {
> > +	for_each_available_child_of_node(np, child) {
> >=20
> >   		struct thermal_zone_device *tzd;
> >=20
> > -		struct qoriq_sensor *sensor =3D &qdata->sensor[id];
> > -		int ret;
> > +		struct qoriq_sensor *sensor;
> > +		int id, site;
> > +
> > +		ret =3D thermal_zone_of_get_sensor_id(child, sensor_np,=20
&id);
> > +
> > +		if (ret < 0) {
> > +			dev_err(dev, "failed to get valid sensor id:=20
%d\n", ret);
> > +			of_node_put(child);
> > +			break;
> > +		}
> >=20
> > +		sensor =3D &qdata->sensor[id];
> >=20
> >   		sensor->id =3D id;
> >=20
> > +		/* Enable monitoring */
> > +		if (qdata->ver =3D=3D TMU_VER1) {
> > +			site =3D 0x1 << (15 - id);
> > +			regmap_update_bits(qdata->regmap, REGS_TMR,
> > +					   site | TMR_ME |=20
TMR_ALPF,
> > +					   site | TMR_ME |=20
TMR_ALPF);
> > +		} else {
> > +			site =3D 0x1 << id;
> > +			regmap_update_bits(qdata->regmap,=20
REGS_V2_TMSR, site, site);
> > +			regmap_write(qdata->regmap, REGS_TMR, TMR_ME=20
| TMR_ALPF_V2);
> > +		}
> > +
> >=20
> >   		tzd =3D devm_thermal_zone_of_sensor_register(dev, id,
> >   	=09
> >   						=09
   sensor,
> >   						=09
   &tmu_tz_ops);
> >=20
> > -		ret =3D PTR_ERR_OR_ZERO(tzd);
> > -		if (ret) {
> > -			if (ret =3D=3D -ENODEV)
> > -				continue;
> > -
> > -			regmap_write(qdata->regmap, REGS_TMR,=20
TMR_DISABLE);
> > -			return ret;
> > +		if (IS_ERR(tzd)) {
> > +			ret =3D PTR_ERR(tzd);
> > +			dev_err(dev, "failed to register thermal=20
zone: %d\n", ret);
> > +			of_node_put(child);
> > +			break;
> >=20
> >   		}
> >   	=09
> >   		if (devm_thermal_add_hwmon_sysfs(tzd))
> >=20
> > @@ -164,7 +181,13 @@ static int qoriq_tmu_register_tmu_zone(struct devi=
ce
> > *dev,>=20
> >   	}
> >=20
> > -	return 0;
> > +	of_node_put(sensor_np);
> > +	of_node_put(np);
> > +
> > +	if (ret)
> > +		regmap_write(qdata->regmap, REGS_TMR, TMR_DISABLE);
> > +
> > +	return ret;
> >=20
> >   }
> >  =20
> >   static int qoriq_tmu_calibration(struct device *dev,




