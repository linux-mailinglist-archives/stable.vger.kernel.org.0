Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 083D959F4D1
	for <lists+stable@lfdr.de>; Wed, 24 Aug 2022 10:12:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231569AbiHXIMy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Aug 2022 04:12:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51708 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231207AbiHXIMw (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 24 Aug 2022 04:12:52 -0400
Received: from sender-of-o50.zoho.in (sender-of-o50.zoho.in [103.117.158.50])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A99E685AB1;
        Wed, 24 Aug 2022 01:12:49 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1661328756; cv=none; 
        d=zohomail.in; s=zohoarc; 
        b=DSlC6MNqXJEKuLWWv9hD5ReOtHPCoIIspX9WVJYwx76RtxpYjqB3NGMU3dedRU3CL1lSicqv3EZfUcnhQ1EJIyaNSME4Ri4EKFI9jmwB5/XzPNh0OL9ammAtpqD7c+41CFO2mL6ydJ8/IvNIpIRJHgo7BvTjDy/4c6AI/9+xwus=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.in; s=zohoarc; 
        t=1661328756; h=Content-Type:Content-Transfer-Encoding:Cc:Date:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:To; 
        bh=nxuDlBnh7rD26c84GHsAUGHCF7GK79bwk7nQ3eQxjyY=; 
        b=eLZ9qpm4vxcJ0enFIjDW/CuyYqacaj3hvYJNWkUIU3lQ6Qmp2Snj7Q1uCQEVHyZaoLtKVXmJ+pb6dSbFJDou1TXhFrAQWVyQ65YIjaWtEQrf11pFVd8nEkcEa75iS3JIAgg8JmVKNe8q3sQ/4V6fxnRE8UyNxwJLN+MVlZbBbo8=
ARC-Authentication-Results: i=1; mx.zohomail.in;
        dkim=pass  header.i=siddh.me;
        spf=pass  smtp.mailfrom=code@siddh.me;
        dmarc=pass header.from=<code@siddh.me>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1661328756;
        s=zmail; d=siddh.me; i=code@siddh.me;
        h=Date:Date:From:From:To:To:Cc:Cc:Message-ID:In-Reply-To:References:Subject:Subject:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-Id:Reply-To;
        bh=nxuDlBnh7rD26c84GHsAUGHCF7GK79bwk7nQ3eQxjyY=;
        b=QXUy31uj4dbboP+XiXGdXmL43R95UeAcwm0xOMj/EcZneZkZEKQG6FCsq/pMFLcU
        mlWD6fj6JCJ9uOXfnN/r9w616HiOgvi2fB8VSl+IxO65Kzi7SB0N2+i5MmCFcs+wT+A
        +zSVw/g3xbbuxu0s5eMM9Z9DXsRVvezkiOxewFWs=
Received: from mail.zoho.in by mx.zoho.in
        with SMTP id 1661328745149618.5620763655653; Wed, 24 Aug 2022 13:42:25 +0530 (IST)
Date:   Wed, 24 Aug 2022 13:42:25 +0530
From:   Siddh Raman Pant <code@siddh.me>
To:     "Jens Axboe" <axboe@kernel.dk>
Cc:     "linux-kernel-mentees" 
        <linux-kernel-mentees@lists.linuxfoundation.org>,
        "stable" <stable@vger.kernel.org>,
        "linux-block" <linux-block@vger.kernel.org>,
        "linux-kernel" <linux-kernel@vger.kernel.org>,
        "syzbot+a8e049cd3abd342936b6" 
        <syzbot+a8e049cd3abd342936b6@syzkaller.appspotmail.com>
Message-ID: <182cee8e2a7.5a62eb4811173.7413734946973464259@siddh.me>
In-Reply-To: <166127140632.124225.483036207879834754.b4-ty@kernel.dk>
References: <20220823160810.181275-1-code@siddh.me> <166127140632.124225.483036207879834754.b4-ty@kernel.dk>
Subject: Re: [PATCH v2] loop: Check for overflow while configuring loop
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Importance: Medium
User-Agent: Zoho Mail
X-Mailer: Zoho Mail
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, 23 Aug 2022 21:46:46 +0530  Jens Axboe  wrote:
> Applied, thanks!
> 
> [1/1] loop: Check for overflow while configuring loop
>       commit: f11ebc7347340d291ba032a3872e40d3283fc351

Thanks!

Though, it seems that you have used the mailing list's address
(linux-kernel-mentees@lists.linuxfoundation.org) in the author
field instead of the Signed-off email.

Thanks,
Siddh
