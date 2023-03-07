Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 83C486AEE47
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 19:11:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232349AbjCGSK7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 13:10:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53910 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232464AbjCGSKZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 13:10:25 -0500
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (mail-dm3nam02on2097.outbound.protection.outlook.com [40.107.95.97])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7BEC0584A3
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 10:05:19 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QgAg0VVp/DFl8k9VAU0vQtJISmdwB8z4PTRh34IUCOki4GeS7Yve/5hmvk28bI2pKK1yBkZrVqgnB9T1eHM5T47VoOzzLMi9klPxdpX4ZjgyQ8SG5fE38bnjCJyiACe68XsyimzI7xUHUS1KS9rCuo+qLMp7iJHTLCyG9d9qdkvgPAnwtvEVTOPIx45d9ND02z7ERrolg+RA37fu2J7IyRGyNIW0maNmr0f0ljyPiXvcV7dAZ/mQurNidPI5XCeEFSDh3CbVvBk9o8q7extwJHMUEM5C3DiA2HHitMp31rY3EygfYvqizjLG/ckQkfkMGY20ODZy8MfGlhAgJ5TWJg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4FXEVYxdpmU0S7x5c/qZV4VmtM3XOu5Jn9UlW1uodFg=;
 b=mmNBrwEG6sFN78xaPggLsiK4yPmbnZL9bNND4eKGmT+TKJS7d39OeTolDrGq61zxBg0hkQQcviaXFfttFKDNfCIQWBXKHQpGO8zgb64NnbFzkAhVtFcxzyGrmxt3fM//xJcE7DRldrZQwSws7e3XTzseOq4fKE1mondRJNe8oUhwRZnmFUzpZsRQFGKlxbuV//ISus/caMSCJjNZpeTAef8wqaPrzHZgEuLUzRayxuT8y4E8yF+AhU+9kZ5noS9plf8pgGxw8Z1sQjPFhG/juF7SAfXBwaHyfsGr9HgZpvLXUT/+2mRFisQWLdZKJL2K0CuZIW5QYx+CBVTvL3Th3w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=in-advantage.com; dmarc=pass action=none
 header.from=in-advantage.com; dkim=pass header.d=in-advantage.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=inadvantage.onmicrosoft.com; s=selector2-inadvantage-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4FXEVYxdpmU0S7x5c/qZV4VmtM3XOu5Jn9UlW1uodFg=;
 b=p7zYkJFc2ZcYRp8nygWHyBhDf7ZOxHxfaIzXjufOLlw5APBQkySQZrSxXi5RQ2gGL84p9yH1Ud7Eur6sWLVK2EozBOXhjAVVuRK3apgi6ohHMcaVC+hGbA4AQh4HUUut7TBN3ThPZPhr/ks9h6OyDmh1WeFdyI3H4Sd91k0O8HU=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=in-advantage.com;
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37) by CO1PR10MB4595.namprd10.prod.outlook.com
 (2603:10b6:303:98::21) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6156.29; Tue, 7 Mar
 2023 18:05:17 +0000
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::1897:6663:87ba:c8fa]) by MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::1897:6663:87ba:c8fa%4]) with mapi id 15.20.6156.027; Tue, 7 Mar 2023
 18:05:16 +0000
Date:   Tue, 7 Mar 2023 12:05:11 -0600
From:   Colin Foster <colin.foster@in-advantage.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, patches@lists.linux.dev,
        Daniel Golle <daniel@makrotopia.org>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 6.2 0410/1001] regmap: apply reg_base and reg_downshift
 for single register ops
Message-ID: <ZAd81x1jNuxvsO4B@MSI.localdomain>
References: <20230307170022.094103862@linuxfoundation.org>
 <20230307170039.123885333@linuxfoundation.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230307170039.123885333@linuxfoundation.org>
X-ClientProxiedBy: CH2PR05CA0021.namprd05.prod.outlook.com (2603:10b6:610::34)
 To MWHPR1001MB2351.namprd10.prod.outlook.com (2603:10b6:301:35::37)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MWHPR1001MB2351:EE_|CO1PR10MB4595:EE_
X-MS-Office365-Filtering-Correlation-Id: 52c3fc50-2d7c-4846-3be3-08db1f368176
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: YkHm70YAaDdXoXI8SyQ869UrVrA0kuRG4te5P1yXYB0GtTTqFkel0+twzcSVK+vt8I7CxrwZNkObD6aiGcnyn51ygdQ1mfdWcEIv6WjFWOJqOL27XYkHuoJhD9f3AyxZxNaE6OAEVbz6GiuBQ8uXWl9wZ31HwXroK0KC2Uwm6I1AEzN2U8KQ6l9uBMUq333eCOHeH6G7FZnP7qE7hUHXDScHiWOQrIUeKvL9QKRajpMpGF40/zX1N1W3GejGrYUQ3QPUIwcaxJ5R9jwkEXh2pfrfMXTXE3X2C0A1wFFYHsb5NqFYAK0GHhS7Va4ioHMTNGbhI8A7C2w99B49sk8XPlqRY3zvO47jS2jpBMYxSBOXZhcDQvBRLMJtG1zVr/foPKaJXmdX1ocCvTfchLYJJ0pm35vHeUW5KuSp/W3le6F/YwiHdZnRhch5TDa0qkrswQv4dXBU0pxOnw53Tj6aRdg5sEoaOd6C3H3HsRMtzhqNRCei62ORpkohUfVtBth6qxA5mZE7W46Fn7b8lWcxz5gyi9+5avKEsMgK+GOKG3Ma21ud+h0fLUziIUTnkqyWQQYrbPjeK3G1baKs6AtjaZSiUPszhp6Ub98PHlPNZjVvSzk0IvnXtMHO8VWLy/7g
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2351.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(396003)(376002)(346002)(366004)(39840400004)(136003)(451199018)(66899018)(41300700001)(8676002)(66556008)(66946007)(38100700002)(66476007)(6916009)(5660300002)(4326008)(44832011)(8936002)(2906002)(86362001)(6506007)(26005)(54906003)(6666004)(186003)(9686003)(478600001)(6512007)(316002)(83380400001)(6486002)(966005);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?QtPDqa7QD1it1MBi7UmmV2SPuKvcm3u9Rf/027P6NVOYAlu9KTHaTw134NDk?=
 =?us-ascii?Q?SqdmlxDS5HFZVi1jktbOfGAwuR6ihPpxg8Dk2M9pS2AMlgdo2dxdd8TnbHSo?=
 =?us-ascii?Q?Qam8g1+xxOUZogNDPX+9jIR9kr9ZdMBFBN1YnSl5qpes8ff+tqHSpFgpA/bS?=
 =?us-ascii?Q?Xdxm3a6o0NHVKaikrKMjLsoKdvXUNFYIWw3M5w36/UZO9RKKLCEo0vHAsZ3s?=
 =?us-ascii?Q?UBYSOadjGxmSa/0mng+CXcu9qmOrJD6LzIzS1mzn/sQdZcggRASJwdkaTj/7?=
 =?us-ascii?Q?jkG5K6EF6KY6WZz3ldWDesrP87I4Vhs4xmyemKEmIeIVlieRMphKDRZ+erIM?=
 =?us-ascii?Q?jTagfMV90mE91d2p9wO/u2WuNiILjYrpu8IM10XhYAIohXsRx6YdoFPHg719?=
 =?us-ascii?Q?MQbvn+vQ754TnBEkBLoCZMw3Ac5/b8SvQFTRGwFSraWlpjdMgZinChXbeKUh?=
 =?us-ascii?Q?wicCoDGH6LROryILgNWpgYO3GqhI9FqEYCo99m3bfS6OUfQeTLdbMjYp8ROs?=
 =?us-ascii?Q?XqaXxxqg1GLOg4zy+tkz1gNcbFv3bCnES6MDiIGtyKyPq7MhQBjtRh8wcmxL?=
 =?us-ascii?Q?h0WPEwvfvVeZM+TgXEeCSXao6RD9PjK6griBLe7xaxu2XdFiDwoZmuaSeD6Z?=
 =?us-ascii?Q?RdJvCKVtBbXdi/0DrjGFObtBFSUSEU7PLifLOVVK8tu/Y9Iv53GbTpNrh3Na?=
 =?us-ascii?Q?+tDMmMCJopxAc8Da/ILT4bh92g7we2h+m0l5cL92zi1HTIsLbxxN67a9U4Ap?=
 =?us-ascii?Q?CwvVNEbDn/lioXcRgS3LOR3MZ9WyAs8g29zD4MCYevjP1+7CGdzdmUsFVKoX?=
 =?us-ascii?Q?awwgfntB1vwC2BRunk7sAmZrSUn4aUdob0MNo7tPGv6dRE/zUFrFbTFOizNu?=
 =?us-ascii?Q?dlWngfjXrkB64ZKgMxShkMbFNCmLp4NuLHApteiudrgDLTUaD7qMD88m9yDR?=
 =?us-ascii?Q?AXl6KkH8iwIIp99kI2oRmpd2kI5Dyg+3OLD1s/hyLm5I/FmIoME8XtH6YVqX?=
 =?us-ascii?Q?k4HsbSTWozQRDzuFbq1/JFt1eD/Ul2ise5Ch25RvZb5AJBneCQrrHs4ptqML?=
 =?us-ascii?Q?cRwkp70mezxSssZ9TTpSCFYoYv+BHqUV1LWqjuIsLVFCzHGewKL7oImm3RFD?=
 =?us-ascii?Q?tgngWfmy8O+8glOdqaxAuxb4HRpeyDmE8dG9UOXA2m/jcCjSzqhZ9oJP3FTS?=
 =?us-ascii?Q?yOoKfCQKB38LRAxH2IETuMwzTH99//yU7WLoR+LpU3T6R2AvYz/KQqo6Yr9E?=
 =?us-ascii?Q?ozlsnkdyxBBoQ5KPawes8SGBvnvAL6xztA5QipmDsbzlWW00zBqCdtg1o7l2?=
 =?us-ascii?Q?vTozgStYdlARJ1wlcXBOw3Ow+ZXwIxEsq6ubpkR9gxcW4G6BsvJDO+MBcoe0?=
 =?us-ascii?Q?sOXEJD5vTGxPHWbBPFo0ypqVvEWUlS/N6A4ILxCyeTu15z1VvUirLEUtKXDr?=
 =?us-ascii?Q?g7ZFz9RFmFj6ZqS1z0qtJRlH1+ikMGDa6ATTnk+ny0vdbkMqD2QozsJ60W70?=
 =?us-ascii?Q?I8jCCuDN2QZUrvhzdxJ8tAROS1e3gVnooRGhyOJ+ZxVQamQ7jhxVzNfjJgVH?=
 =?us-ascii?Q?Az1L2qFNJcIOmAE/oMkEmMfHIhuvJE46q5k9rB6Okxc3tmLgUlQm3bMS3QIc?=
 =?us-ascii?Q?5iq9MysQV4h96Fhl8WsLwdY=3D?=
X-OriginatorOrg: in-advantage.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 52c3fc50-2d7c-4846-3be3-08db1f368176
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2351.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Mar 2023 18:05:16.5480
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 48e842ca-fbd8-4633-a79d-0c955a7d3aae
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +d0Le+048kK0g/dzh3f7t8F5zCTn05bizQCyqSBRlA+hXF+oFnZN+/8WYrCvYQR3eqeW2+6o8m7YlqxyM8v9UuFAznM0B+nxVTTQMqDimTc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR10MB4595
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Greg,

On Tue, Mar 07, 2023 at 05:53:02PM +0100, Greg Kroah-Hartman wrote:
> From: Daniel Golle <daniel@makrotopia.org>
> 
> [ Upstream commit 697c3892d825fb78f42ec8e53bed065dd728db3e ]
> 
> reg_base and reg_downshift currently don't have any effect if used with
> a regmap_bus or regmap_config which only offers single register
> operations (ie. reg_read, reg_write and optionally reg_update_bits).
> 
> Fix that and take them into account also for regmap_bus with only
> reg_read and read_write operations by applying reg_base and
> reg_downshift in _regmap_bus_reg_write, _regmap_bus_reg_read.
> 
> Also apply reg_base and reg_downshift in _regmap_update_bits, but only
> in case the operation is carried out with a reg_update_bits call
> defined in either regmap_bus or regmap_config.

I was waiting for this one to be back-ported. Anyone else can disagree
with me, but I'm on the fence as to whether it should go back to
stable branches.

The only user of reg_base and reg_downshift in 6.1 / 6.2 is
drivers/mfd/ocelot-spi.c, and these don't use reg_read() or reg_write()
so are unaffected by this fix.

On one hand, it isn't fixing any existing 'bugs'. On the other hand,
the documentation I wrote was confusing / misleading, and people
developing against the stable kernels might get behavior that they
didn't expect. Daniel had the misfortune of experiencing this.

Again, I'm on the fence - I just want to make sure the scope is
understood.


Thanks!

> 
> Fixes: 0074f3f2b1e43d ("regmap: allow a defined reg_base to be added to every address")
> Fixes: 86fc59ef818beb ("regmap: add configurable downshift for addresses")
> Signed-off-by: Daniel Golle <daniel@makrotopia.org>
> Tested-by: Colin Foster <colin.foster@in-advantage.com>
> Link: https://lore.kernel.org/r/Y9clyVS3tQEHlUhA@makrotopia.org
> Signed-off-by: Mark Brown <broonie@kernel.org>
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
>  drivers/base/regmap/regmap.c | 6 ++++++
>  1 file changed, 6 insertions(+)
> 
> diff --git a/drivers/base/regmap/regmap.c b/drivers/base/regmap/regmap.c
> index d12d669157f24..d2a54eb0efd9b 100644
> --- a/drivers/base/regmap/regmap.c
> +++ b/drivers/base/regmap/regmap.c
> @@ -1942,6 +1942,8 @@ static int _regmap_bus_reg_write(void *context, unsigned int reg,
>  {
>  	struct regmap *map = context;
>  
> +	reg += map->reg_base;
> +	reg >>= map->format.reg_downshift;
>  	return map->bus->reg_write(map->bus_context, reg, val);
>  }
>  
> @@ -2840,6 +2842,8 @@ static int _regmap_bus_reg_read(void *context, unsigned int reg,
>  {
>  	struct regmap *map = context;
>  
> +	reg += map->reg_base;
> +	reg >>= map->format.reg_downshift;
>  	return map->bus->reg_read(map->bus_context, reg, val);
>  }
>  
> @@ -3231,6 +3235,8 @@ static int _regmap_update_bits(struct regmap *map, unsigned int reg,
>  		*change = false;
>  
>  	if (regmap_volatile(map, reg) && map->reg_update_bits) {
> +		reg += map->reg_base;
> +		reg >>= map->format.reg_downshift;
>  		ret = map->reg_update_bits(map->bus_context, reg, mask, val);
>  		if (ret == 0 && change)
>  			*change = true;
> -- 
> 2.39.2
> 
> 
> 
