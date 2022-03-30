Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 00A9D4EC962
	for <lists+stable@lfdr.de>; Wed, 30 Mar 2022 18:11:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348654AbiC3QN1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 30 Mar 2022 12:13:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53350 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348201AbiC3QN0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 30 Mar 2022 12:13:26 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 458523A5F4;
        Wed, 30 Mar 2022 09:11:41 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D8E616179D;
        Wed, 30 Mar 2022 16:11:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD07AC340EE;
        Wed, 30 Mar 2022 16:11:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1648656700;
        bh=HKBFbgRN2o7dvjnaa2WfwvGDO1YbNcTIMLeaL7086go=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=nmjOUEK/PYt4+DJyh6EMO5l9zGj4rLWQtRFmFeQjW6IxTPGVaaR1VOUepIJCHTDMh
         CiDNyqtCeGtWc2uTCyszxKNkCQCL6ZTNxZC1DOTVZ8gi4mqVfkrMdLxuVT4EZgMM9S
         i4fZisEQWDy+rZe84wpcaylJgIJ/ne4fiUXTxM5Q5b1SWL5gfEhTAuXrcMmwU4P17y
         B3EHe5DUaBideyBrMCCkW9Iw49/N82l7QF+nUJu6weIFeHJtP81yC4NbXo559B3Z3Y
         dDfvKlzcieL1o9sw0PHibHGriCAe6B5LK7rDTsI7StYrU/0aqzqwwEpUMGbQ6PC7IQ
         iW6ms23L5Lm/Q==
Date:   Wed, 30 Mar 2022 18:11:34 +0200
From:   Christian Brauner <brauner@kernel.org>
To:     Christoph Hellwig <hch@lst.de>
Cc:     Amir Goldstein <amir73il@gmail.com>,
        Miklos Szeredi <mszeredi@redhat.com>,
        Al Viro <viro@zeniv.linux.org.uk>,
        linux-fsdevel@vger.kernel.org, linux-unionfs@vger.kernel.org,
        Aleksa Sarai <cyphar@cyphar.com>,
        Giuseppe Scrivano <gscrivan@redhat.com>,
        Rodrigo Campos Catelin <rodrigo@sdfg.com.ar>,
        Seth Forshee <sforshee@digitalocean.com>,
        Luca Bocassi <luca.boccassi@microsoft.com>,
        Lennart Poettering <mzxreary@0pointer.de>,
        =?utf-8?B?U3TDqXBoYW5l?= Graber <stgraber@ubuntu.com>,
        stable@vger.kernel.org
Subject: Re: [PATCH v2 02/19] exportfs: support idmapped mounts
Message-ID: <20220330161134.ulgmb4ryzv5ywpof@wittgenstein>
References: <20220330102409.1290850-1-brauner@kernel.org>
 <20220330102409.1290850-3-brauner@kernel.org>
 <20220330152635.GB4835@lst.de>
 <20220330160448.bugfza2akk3zsici@wittgenstein>
 <20220330160816.GA5633@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20220330160816.GA5633@lst.de>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Mar 30, 2022 at 06:08:16PM +0200, Christoph Hellwig wrote:
> On Wed, Mar 30, 2022 at 06:04:48PM +0200, Christian Brauner wrote:
> > > This probably wants a Fixes tag, as without it NFS exporting idmapped
> > > file will give slightly unexpected results.
> > 
> > I made it so that the nfs kernel server will refuse to be mounted on top
> > of idmapped mounts in check_export() similar to what I did originally do
> > for overlayfs. It's unclear what the Fixes: tag would be so I'll just Cc
> > stable.
> 
> So knfsd is fine, and the handle_to_name syscall doesn't ever do the
> equivalent of the subtree check.  So with that we probably don't need
> a Fixes tag - sorry for the noise.

No worries, thank you for taking a close look!
