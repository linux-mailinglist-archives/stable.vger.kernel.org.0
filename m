Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9CF4457A700
	for <lists+stable@lfdr.de>; Tue, 19 Jul 2022 21:14:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239095AbiGSTOo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Jul 2022 15:14:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36378 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239545AbiGSTOl (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 19 Jul 2022 15:14:41 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4CA9855089;
        Tue, 19 Jul 2022 12:14:38 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id DAF47B81CE0;
        Tue, 19 Jul 2022 19:14:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A807C341C6;
        Tue, 19 Jul 2022 19:14:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1658258075;
        bh=kj+j4LdZbURAimMqvavoqpdo7V8TFhnzwjnOiiEINwM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=GRG2xSrX3lgNWKZaLuW+av+pMlA+IJxf6K09GiMJEKLPc4kCcie861TE4BwLiggbv
         6AzpObcIKOpAmVyg1PVbUCmlAWus157LPTHLb4JZv4w2Pf92vlXi9uyirjxkf/rdq7
         6YErMM9GI2r42nKuuuTz4LiWCA7hrWQ4MOPOrcsE=
Date:   Tue, 19 Jul 2022 21:14:32 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Theodore Ts'o <tytso@mit.edu>
Cc:     Baokun Li <libaokun1@huawei.com>, stable@vger.kernel.org,
        linux-ext4@vger.kernel.org, adilger.kernel@dilger.ca, jack@suse.cz,
        ritesh.list@gmail.com, lczerner@redhat.com, enwlinux@gmail.com,
        linux-kernel@vger.kernel.org, yi.zhang@huawei.com,
        yebin10@huawei.com, yukuai3@huawei.com,
        Hulk Robot <hulkci@huawei.com>
Subject: Re: [PATCH 4.19] ext4: fix race condition between
 ext4_ioctl_setflags and ext4_fiemap
Message-ID: <YtcCmILbA9mTh4Au@kroah.com>
References: <20220715023928.2701166-1-libaokun1@huawei.com>
 <YtF1XygwvIo2Dwae@kroah.com>
 <425ab528-7d9a-975a-7f4c-5f903cedd8bc@huawei.com>
 <YtaVAWMlxrQNcS34@kroah.com>
 <ffb13c36-521e-0e06-8fd6-30b0fec727da@huawei.com>
 <YtairkXvrX6IZfrR@kroah.com>
 <Ytb+ji56S/de/5Rm@mit.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Ytb+ji56S/de/5Rm@mit.edu>
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jul 19, 2022 at 02:57:18PM -0400, Theodore Ts'o wrote:
> P.S.  If we go down this path, Greg K-H may also insist on getting the
> bug fix to the 5.4 LTS kernel, so that a bug isn't just fixed in 4.19
> LTS but not 5.4 LTS.  In which case, the same requirement of running
> "-c ext4/all -g auto" and showing that there are no test regressions
> is going to be a requirement for 5.4 LTS as well.

Yes, if this issue is also in 5.4 or any newer kernels, it HAS to be
fixed there at the same time, or before, as we can not have anyone
upgrading from an older kernel to a newer one and having a regression.

thanks,

greg k-h
