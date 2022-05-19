Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A965B52DAF1
	for <lists+stable@lfdr.de>; Thu, 19 May 2022 19:14:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233983AbiESRL6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 May 2022 13:11:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33162 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242457AbiESRLz (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 19 May 2022 13:11:55 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6BC032DD77;
        Thu, 19 May 2022 10:11:37 -0700 (PDT)
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out1.suse.de (Postfix) with ESMTP id 21E1221B3D;
        Thu, 19 May 2022 17:11:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1652980296; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=rWh53tGkveY7idEYFsxjbZWpUxq42gDwANR/tTyoynA=;
        b=GxK3G4QLKN08IdF1ihND5wQ2Ww5O75CoNT+XUN7JDy50/venD87zCA7NNiKGjKc7afCOQl
        AJJ5F93tVyNCQykjtCBVlUCg2y+WuJP5RKwsDcYZqyf5Ay+FiM9ovzjRmUPAtQ/D/K6glv
        t+j3pn2by0hLM1Kv95IUGaIORWEpBlw=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1652980296;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=rWh53tGkveY7idEYFsxjbZWpUxq42gDwANR/tTyoynA=;
        b=VMNYKei+gBjUYDhmu+fbZxs5FqWeJIPthSZxCZVqoA4oKbJkLMG5IVS8fNKOmI9Y3PrJ+X
        8Tz99XX8TMgJYqAg==
Received: from kunlun.suse.cz (unknown [10.100.128.76])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by relay2.suse.de (Postfix) with ESMTPS id 885302C141;
        Thu, 19 May 2022 17:11:35 +0000 (UTC)
Date:   Thu, 19 May 2022 19:11:34 +0200
From:   Michal =?iso-8859-1?Q?Such=E1nek?= <msuchanek@suse.de>
To:     Baoquan He <bhe@redhat.com>
Cc:     Mimi Zohar <zohar@linux.ibm.com>, Coiby Xu <coxu@redhat.com>,
        Heiko Carstens <hca@linux.ibm.com>, akpm@linux-foundation.org,
        kexec@lists.infradead.org, keyrings@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Dave Young <dyoung@redhat.com>, Will Deacon <will@kernel.org>,
        "Eric W . Biederman" <ebiederm@xmission.com>,
        Chun-Yi Lee <jlee@suse.com>, stable@vger.kernel.org,
        Philipp Rudo <prudo@linux.ibm.com>,
        linux-security-module@vger.kernel.org,
        Vasily Gorbik <gor@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Sven Schnelle <svens@linux.ibm.com>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        "open list:S390" <linux-s390@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        linux-integrity <linux-integrity@vger.kernel.org>,
        Jarkko Sakkinen <jarkko@kernel.org>
Subject: Re: [PATCH v8 4/4] kexec, KEYS, s390: Make use of built-in and
 secondary keyring for signature verification
Message-ID: <20220519171134.GN163591@kunlun.suse.cz>
References: <20220512070123.29486-1-coxu@redhat.com>
 <20220512070123.29486-5-coxu@redhat.com>
 <YoTYm6Fo1vBUuJGu@osiris>
 <20220519003902.GE156677@MiWiFi-R3L-srv>
 <c47299b899da4ad4b6d3ad637022ad82c8ed6ed2.camel@linux.ibm.com>
 <YoZSl84aJYTscgfO@MiWiFi-R3L-srv>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YoZSl84aJYTscgfO@MiWiFi-R3L-srv>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, May 19, 2022 at 10:22:15PM +0800, Baoquan He wrote:
> On 05/19/22 at 07:56am, Mimi Zohar wrote:
> > [Cc'ing Jarkko, linux-integrity]
> > 
> > On Thu, 2022-05-19 at 08:39 +0800, Baoquan He wrote:
> > > On 05/18/22 at 01:29pm, Heiko Carstens wrote:
> > > > On Thu, May 12, 2022 at 03:01:23PM +0800, Coiby Xu wrote:
> > > > > From: Michal Suchanek <msuchanek@suse.de>
> > > > > 
> > > > > commit e23a8020ce4e ("s390/kexec_file: Signature verification prototype")
> > > > > adds support for KEXEC_SIG verification with keys from platform keyring
> > > > > but the built-in keys and secondary keyring are not used.
> > > > > 
> > > > > Add support for the built-in keys and secondary keyring as x86 does.
> > > > > 
> > > > > Fixes: e23a8020ce4e ("s390/kexec_file: Signature verification prototype")
> > > > > Cc: stable@vger.kernel.org
> > > > > Cc: Philipp Rudo <prudo@linux.ibm.com>
> > > > > Cc: kexec@lists.infradead.org
> > > > > Cc: keyrings@vger.kernel.org
> > > > > Cc: linux-security-module@vger.kernel.org
> > > > > Signed-off-by: Michal Suchanek <msuchanek@suse.de>
> > > > > Reviewed-by: "Lee, Chun-Yi" <jlee@suse.com>
> > > > > Acked-by: Baoquan He <bhe@redhat.com>
> > > > > Signed-off-by: Coiby Xu <coxu@redhat.com>
> > > > > ---
> > > > >  arch/s390/kernel/machine_kexec_file.c | 18 +++++++++++++-----
> > > > >  1 file changed, 13 insertions(+), 5 deletions(-)
> > > > 
> > > > As far as I can tell this doesn't have any dependency to the other
> > > > patches in this series, so should I pick this up for the s390 tree, or
> > > > how will this go upstream?
> > > 
> > > Thanks, Heiko.
> > > 
> > > I want to ask Mimi if this can be taken into KEYS-ENCRYPTED tree.
> > > Otherwise I will ask Andrew to help pick this whole series.
> > > 
> > > Surely, this patch 4 can be taken into s390 seperately since it's
> > > independent, both looks good.
> > 
> > KEYS-ENCRYTPED is a type of key, unrelated to using the .platform,
> > .builtin, .machine, or .secondary keyrings.  One of the main reasons
> > for this patch set is to use the new ".machine" keyring, which, if
> > enabled, is linked to the "secondary" keyring.  However, the only
> > reference to the ".machine" keyring is in the cover letter, not any of
> > the patch descriptions.  Since this is the basis for the system's
> > integrity, this seems like a pretty big omission.
> > 
> > From patch 2/4:
> > "The code in bzImage64_verify_sig makes use of system keyrings
> > including
> > .buitin_trusted_keys, .secondary_trusted_keys and .platform keyring to
> > verify signed kernel image as PE file..."
> > 
> > From patch 3/4:
> > "This patch allows to verify arm64 kernel image signature using not
> > only
> > .builtin_trusted_keys but also .platform and .secondary_trusted_keys
> > keyring."
> > 
> > From patch 4/4:
> > "... with keys from platform keyring but the built-in keys and
> > secondary keyring are not used."
> > 
> > This patch set could probably go through KEYS/KEYRINGS_INTEGRITY, but
> > it's kind of late to be asking.  Has it been in linux-next?  Should I
> > assume this patch set has been fully tested or can we get some "tags"?
> 
> Right, it should be KEYS/KEYRINGS_INTEGRITY related, I made mistaken.
> Now it got two ACKs from Michal and me. Michal met the same issue on
> arm64 and posted another series of patches, finally Coiby integrated
> Michal's patch and his to make this patchset. That would be great if
> this can get reviewing from experts on key/keyring. Surely, Coiby need
> update the patch log to add the '.machine' keyring into patch logs as
> you pointed out.
> 
> IIRC, Coiby has tested it on x86_64/arm64, not sure if he took test on
> s390. No, this hasn't been in linux-next.

I used the s390 code on powerpc and there it did not work because the
built-in key was needed to verify the kernel.

I did not really run this on s390, only ported the fix I needed on
powerpc back to s390.

Thanks

Michal
