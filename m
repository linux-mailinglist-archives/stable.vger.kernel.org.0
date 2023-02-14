Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E8403696D2A
	for <lists+stable@lfdr.de>; Tue, 14 Feb 2023 19:45:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232342AbjBNSp4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Feb 2023 13:45:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39148 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231944AbjBNSpz (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 14 Feb 2023 13:45:55 -0500
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 63F98A274;
        Tue, 14 Feb 2023 10:45:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1676400354; x=1707936354;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=sUtVE+ovoVSvE+ojAT/Up0Q//SZcQLHqI4L0vB5VtZ8=;
  b=gqHjStB6cD/DMEMYwHo+EEugXwVyMic9TDNw3e4OBVme8VGJ4ligDZDk
   g/D8FCOAklcfEYILGVeHFTwC0QLklHTmSiMZu7Mp5lDrhMyHMW574FjzR
   OTQfNj5Z0DR9qdNJBQPhkTfCNm1Y5Ry159lEKut1sjRhmgdLNgqlVuaVB
   SGp+Ku3QkL/qThPpf0HHe3lTldNpN7PrXsAGa3TgEmixGleDOoPJNxmWo
   BRU9Yf3glx5g9F9Hobg+tcNpHeLZX4RMIT0x/OlHkaYA9GlXX0540GNn8
   ItPLurDLG/y2o+LgF6OPY8QVjA6V1rKW2Jd2PK3ThRnoJ6AJmpZW1b37Q
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10621"; a="329864704"
X-IronPort-AV: E=Sophos;i="5.97,297,1669104000"; 
   d="scan'208";a="329864704"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Feb 2023 10:45:54 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10621"; a="914840522"
X-IronPort-AV: E=Sophos;i="5.97,297,1669104000"; 
   d="scan'208";a="914840522"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by fmsmga006.fm.intel.com with ESMTP; 14 Feb 2023 10:45:53 -0800
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Tue, 14 Feb 2023 10:45:53 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Tue, 14 Feb 2023 10:45:53 -0800
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Tue, 14 Feb 2023 10:45:53 -0800
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (104.47.73.176)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Tue, 14 Feb 2023 10:45:51 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ab5XJjA9Xh7u5v3MQpz5yKrqCul4kYBBjbdt+qMJDvdr2C0YMaEUVb7M3ZladObyK1cVQXiTWnda1I0sDyN7uP73hJLOK59glIWis1XqIJJLYTgT+BWZHAkLcmu5QKau09sDHuvmikQ5nFRWS/AjirPru6i/Z5qkg9gu2YYlJOQDk2nCr4GVkevwTUeP6fbkZ4xSIm1EeO3U0qn+trJTGtYIEz6ab0Iei9k751vwSZ+5fl36bE4zx+S3vYx9gJAMTGsRFfjiQsyaPvvWLBfjaePKmjfl601J70d+mQk30R/C4R2yD0CPdHZGUflWjhl/nb35NwBWcEAtadN6/wa9tA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=IoQ6jp5qa41W+MvUzilT+lCTHkK2u15es8+tQtLNIA8=;
 b=fdyyt9+DqH4yJ1H0ge6NLIAHwSKgMnYFbw1RnMr8bUZpkd9QQRYsbSJxUBuSyR/D3tXcTfbnYEKfKrc0UmCtTDcE6WUSYETQbFAYETiwa0A24XtIfzr36JwuMAhivpXrwmG5vbItjzvL4svRRUO40Oxl4GERC0Lhss69MIfK60nbDbP0PScxjDXtIxisxmdUkGaBCpWHqRAfctXMqubxBy8pw/81KQYUBsN3nFHkTZDVIjSM2cdhxo9lxWRlPf59vx87vqP35gfvl9n3bmiC6t0dRjjgnfc5m4TAvYQrh/Sdp+bnLp8S+bCGj5/5+LTe0YnuagppbjwD65TgjJj3gA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH8PR11MB8107.namprd11.prod.outlook.com (2603:10b6:510:256::6)
 by MW4PR11MB7151.namprd11.prod.outlook.com (2603:10b6:303:220::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6086.23; Tue, 14 Feb
 2023 18:45:48 +0000
Received: from PH8PR11MB8107.namprd11.prod.outlook.com
 ([fe80::421b:865b:f356:7dfc]) by PH8PR11MB8107.namprd11.prod.outlook.com
 ([fe80::421b:865b:f356:7dfc%5]) with mapi id 15.20.6086.024; Tue, 14 Feb 2023
 18:45:48 +0000
Date:   Tue, 14 Feb 2023 10:45:46 -0800
From:   Dan Williams <dan.j.williams@intel.com>
To:     David Hildenbrand <david@redhat.com>,
        Dan Williams <dan.j.williams@intel.com>,
        <linux-cxl@vger.kernel.org>
CC:     Kees Cook <keescook@chromium.org>, <stable@vger.kernel.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Michal Hocko <mhocko@suse.com>, <linux-mm@kvack.org>,
        <linux-acpi@vger.kernel.org>
Subject: Re: [PATCH 00/18] CXL RAM and the 'Soft Reserved' => 'System RAM'
 default
Message-ID: <63ebd6da1c4f4_32d612948c@dwillia2-xfh.jf.intel.com.notmuch>
References: <167564534874.847146.5222419648551436750.stgit@dwillia2-xfh.jf.intel.com>
 <ed85ee75-1507-3f72-2af7-40ba452402f4@redhat.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <ed85ee75-1507-3f72-2af7-40ba452402f4@redhat.com>
X-ClientProxiedBy: SJ0PR13CA0010.namprd13.prod.outlook.com
 (2603:10b6:a03:2c0::15) To PH8PR11MB8107.namprd11.prod.outlook.com
 (2603:10b6:510:256::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH8PR11MB8107:EE_|MW4PR11MB7151:EE_
X-MS-Office365-Filtering-Correlation-Id: 75e13f37-5800-4f9e-1915-08db0ebbb024
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: gDeeKrtl61dbndo+A/QowQw2rxwA8jDpYbN3OYig6gFtcYsu9YYJL1hnbI/JmRfDoGHAe0hwd/bOsguJUP0zhg8VaGEB37gnykv8Ge+k80N5lD41Ce5eFkGHhcOwBfQSKsmXGo7DSrQ/4ZknP4UdGHf2dfM3sKJTktB7o4BEwIuVoWBY5UB0VG3nyIupqaRSexRg4fnQvfx5PC/LWnxg5LVhG7xp3uEXz4vRf5dC/Hi0/tyXlAA17aL5KPJXHd8y1M6o/a9vE+CJtLIH2MI7q2QZD4slytMiaJrRNiCDi9q3CFvcexnH8+eXe78/ildYLwqkjvVgBSnmQVS4/vDsZAhymB61En4G47ee7XWJP0aasxNgSDZu4HLZPfPtgaaBCRomNILhVEuUgdSBfsj1Tji0LnG+CwYq+Qh6h2UW6VgG1BNKAGZq45Lkja2awHuNjJxOXzTmDMJ7ow+tZ4OpLu2TtVf+/y6hhsVhmE2NCIbppImEPNBBC6G1ybEq360Zy4OPxkaxdN5IA0lJRVTmcb/DAMaCFfLXCvvdGwuBJGwUhpBDrWLEg4dzIL+IrkyKd7HWLgDmwIPFDM+ZagnHO4jfk+i2UA6f/+ysNgh3tLhTExSp9t+vQkLU65NcOaXRYRM9C360S+WBjWC2dB59+g==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH8PR11MB8107.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(39860400002)(136003)(396003)(376002)(366004)(346002)(451199018)(38100700002)(2906002)(8936002)(82960400001)(66476007)(66556008)(4326008)(66946007)(8676002)(5660300002)(26005)(41300700001)(110136005)(86362001)(478600001)(6486002)(54906003)(186003)(6506007)(6512007)(9686003)(316002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?vsJgK2zV/lI5zpxLRtUahm8PGUxO1lazygZvJEralG4dUMnmX5fpDV67e2Xr?=
 =?us-ascii?Q?rTNKrK31hWyuE7ImLUvppwIazd0GEJEtaz9h63g4bsh/no33m1H0VnULFfUL?=
 =?us-ascii?Q?qd8OlvjHlXuVmIpd02wK17JZGsvUDEorxnIm4QUBUkWqBLe1Gw5QgvqJ0jNp?=
 =?us-ascii?Q?DMxzgK16d8mqgAjvYJv9ZLulnoo7sQ/8WDzaKPMN5odEaF/jjMHmrJMe5t4Y?=
 =?us-ascii?Q?02/wxSV1kOumj/hO4xIwl3kx79cwgxPC7uYRppfneARuXS2VoopIXl9vyb3B?=
 =?us-ascii?Q?prRaqMZ5RIIF9kvULNod1Szb6vKn2aueeF2JWWSjXyqFFPSvlg6lacAAZLpN?=
 =?us-ascii?Q?U+wts1rrGQ9159Ipnf9Dv6NaG2B1beDx/Y7EpzruigFYj48vzQGNEXdB6amz?=
 =?us-ascii?Q?/ykew4clPDl1FOcxuihiJ5igx71CrCIAry2PuapCA3onGJ5rRA2eqB2P/NLx?=
 =?us-ascii?Q?RDAZsVybBmPzSqowd93hSovwW+kvcP+ejLzP7dIb74fcmdEHoyDAMSQt2+JB?=
 =?us-ascii?Q?FZNDMyFoSscLdP1TcLqjX0MBIcYSMI6prfQqcja0Kr0nwA3PdjtXU53Dewc2?=
 =?us-ascii?Q?6td9tgVT2wtxTPqOyfQm+qiJFz21PscuQsuv432NkyaybZ42jmAgoG/cDXnt?=
 =?us-ascii?Q?wDdwHOZvWd9u54yfXVpvCqjl2jYSJWXcqt33s24pCuGgTNXvm9mtRLbOsXdx?=
 =?us-ascii?Q?CF2lT2Qc3nmId6sPIfkS7qHWO3+fiGDSvNNWfuhEA4RiI0QIkmdazaaXb7Eh?=
 =?us-ascii?Q?EQck1+b8KF5rrQ2J4LZV6Xq4w7UVmJemnMXdvUYYVLgcKGohwjv9Bsbuz6TB?=
 =?us-ascii?Q?0CeckNsCiOle9OQqXmyLRXyu/fER8EvVugTHAyC84KDmz+XtNYx28GSVulB5?=
 =?us-ascii?Q?4iB5Ug4OFuIvcb/5jrpsC9uuxV7v1T5rXgzHAFyHE5rkjmLwLNjpbqaJUYSJ?=
 =?us-ascii?Q?nx6NCBvHQHmk3Yi7ibd4lqmo8GavEZ8ymiouLLNMt1C4G01DYzib9VYKfj7y?=
 =?us-ascii?Q?+/hy7wZoZRwVlKaurmr0fS1itOInIQafYpYu2UyxUuAvXUl+6wSUirvcNm3j?=
 =?us-ascii?Q?gssZ3WIaJpqY81FIW/maidMGyOy52dWDmDJxn7avd4tWJ3PVS1nXsW3qBR3t?=
 =?us-ascii?Q?CyWFMTwVLMWWxCYzM0AzhbFj9lmEBxUntXgojzEhEWzvg3xq9hpcFpZx/gH8?=
 =?us-ascii?Q?QLCUQR0XBAG7XtHiP3kqG7l0mTNFMDy5diXFSlrcafOI9NleEB985L0i93tD?=
 =?us-ascii?Q?ny1lsAo2mNEhzzlo1MYjRW+Mqr8934ojHGTP3qgAcOErj8QLDXzblBPiqyF1?=
 =?us-ascii?Q?0noMl+JCeOapaC4mWHnaT5cthETT/g4DhJFsm0Hu76QsHlKGGq2kp5lemfkh?=
 =?us-ascii?Q?Z3mK4bDoQntPWKScTCKwZ2Oir+BjqROZZ5aaurMtESsbBXVLI0s9lqqcfxQg?=
 =?us-ascii?Q?L+QRMBbb0po0MVf+Wa+BuHRW+sGk3DPAK768A7i8h/s1AKCGiCSueSYDLhps?=
 =?us-ascii?Q?0Hlha5Gme+s8GV7xVDkxp8cHosSwmKGBy4Ejbrbc5mPd57N/n98DN3yEfwWo?=
 =?us-ascii?Q?qZ84pD/upJMqW+O1vGEY0+2WRLQT3FAq6eBhD2TlBgLMaFSJoJ6JEFhN5YEw?=
 =?us-ascii?Q?tg=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 75e13f37-5800-4f9e-1915-08db0ebbb024
X-MS-Exchange-CrossTenant-AuthSource: PH8PR11MB8107.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Feb 2023 18:45:48.1292
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /xVtRSHME+lmUnAwffp7iVaBl9zfIFgpzAImKhXpdb0CeU+xwsSnrSTkV8N2Jt2NYtOIKl+R76yndw0BIbCrYCKJchen9iGujBV0Kh7/J/E=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR11MB7151
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

David Hildenbrand wrote:
[..]
> My concern would be that in setups with a lot of CXL memory 
> (soft-reserved), having that much offline memory during boot might make 
> the kernel run out of memory. After all, offline memory consumes memory 
> for the memmap.
> 
> Is the assumption that something like that cannot happen because we'll 
> never ever have that much soft-reserved memory? :)

Right, the assumption is that platform firmware is going to pick a
reasonable general purpose pool that lets an OS boot. In the near term
it is difficult to get that wrong since it will encompass all locally
attached DDR-DRAM. In the longer term, where it becomes possible that
all memory is CXL attached, then platform firmware will need to mark
some or all of CXL memory as general purpose (not Soft Reserved).

> Note that this is a concern only applies when not using auto-onlining in 
> the kernel during boot, which (IMHO) is or will be the default in the 
> future.

Yes, I expect that to be the default as well and let those small few
that have custom requirements figure out how to override that default.
