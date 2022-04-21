Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8120550A1EB
	for <lists+stable@lfdr.de>; Thu, 21 Apr 2022 16:16:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1389099AbiDUOT0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 21 Apr 2022 10:19:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56226 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1389096AbiDUOT0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 21 Apr 2022 10:19:26 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 885783B57E;
        Thu, 21 Apr 2022 07:16:36 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 22C5060FCA;
        Thu, 21 Apr 2022 14:16:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 022CAC385A1;
        Thu, 21 Apr 2022 14:16:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1650550595;
        bh=4rKt3ppzHKCFHR7w6YkhXzMRBVU2PmjeK9/thUqymA4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=b2hJ9Dr9taTb/KjpCkxdiOVxUMuKBaHaAEWZZx6d/0jOlom0o9uYTTJxCMyBMTT3u
         2hwJbWWXkdCrOgA+xg1D1lb2iSltZKsk+ayZNt1NWUNGGcmtHRvxgWqHHjxStWD0J3
         oHcm7m0kPxf0CcCfy97JkzuJAJoYfvPmFYiUf/iY=
Date:   Thu, 21 Apr 2022 16:16:32 +0200
From:   "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
To:     Peter Wang =?utf-8?B?KOeOi+S/oeWPiyk=?= <peter.wang@mediatek.com>
Cc:     "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "avri.altman@wdc.com" <avri.altman@wdc.com>,
        "alim.akhtar@samsung.com" <alim.akhtar@samsung.com>,
        "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Yee Lee =?utf-8?B?KOadjuW7uuiqvCk=?= <Yee.Lee@mediatek.com>,
        Stanley Chu =?utf-8?B?KOacseWOn+mZnik=?= 
        <stanley.chu@mediatek.com>,
        Powen Kao =?utf-8?B?KOmrmOS8r+aWhyk=?= <Powen.Kao@mediatek.com>,
        Alice Chao =?utf-8?B?KOi2meePruWdhyk=?= 
        <Alice.Chao@mediatek.com>
Subject: Re: backport commit ("2bd3b6b75946db2ace06e145d53988e10ed7e99a [v1]
 scsi: ufs: scsi_get_lba error fix by check cmd opcode") to
 linux-5.15/linux-5.16/linux-5.17
Message-ID: <YmFnQNSoEjsousM0@kroah.com>
References: <PSAPR03MB5605E998674382AE0BF53AC7ECF49@PSAPR03MB5605.apcprd03.prod.outlook.com>
 <PSAPR03MB5605D50B15FEB10D57FBDFF3ECF49@PSAPR03MB5605.apcprd03.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <PSAPR03MB5605D50B15FEB10D57FBDFF3ECF49@PSAPR03MB5605.apcprd03.prod.outlook.com>
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Apr 21, 2022 at 01:44:33PM +0000, Peter Wang (王信友) wrote:
> Hi reviewers,
> 
> 
> 
> I suggest to backport
> 
> commit "2bd3b6b75946db2ace06e145d53988e10ed7e99a [v1] scsi: ufs: scsi_get_lba error fix by check cmd opcode"
> 
> to linux-5.15/linux-5.16/linux-5.17 tree.
> 
> 
> 
> This patch fix scsi_get_lba issue by
> 
> https://github.com/torvalds/linux/commit/54815088859fa766c7879a06ee028e0cee4f589e
> 
> 
> 
> commit: 2bd3b6b75946db2ace06e145d53988e10ed7e99a
> 
> subject: [v1] scsi: ufs: scsi_get_lba error fix by check cmd opcode

Now queued up, thanks.

greg k-h
