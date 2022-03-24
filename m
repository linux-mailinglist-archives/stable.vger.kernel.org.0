Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5DC3E4E64FC
	for <lists+stable@lfdr.de>; Thu, 24 Mar 2022 15:19:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346585AbiCXOVQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 24 Mar 2022 10:21:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33110 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350848AbiCXOVP (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 24 Mar 2022 10:21:15 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC526517E2
        for <stable@vger.kernel.org>; Thu, 24 Mar 2022 07:19:43 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7EA94B8232E
        for <stable@vger.kernel.org>; Thu, 24 Mar 2022 14:19:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C09A2C340F2;
        Thu, 24 Mar 2022 14:19:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1648131581;
        bh=+0GGeYLJOxFLt7jSp8tjiNzizQGT/8cw4vZSwGWqRuY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=vI+GvDSieAho/dAeerdk5OD7HDqPqPpqUqUddaIkMJaHIY4BWRkI6k33U+jDzBKZq
         NLGLOmhqjG0cYWSTX+euU1XStBQZl8Z6JgJ3N/O5A+PeVvUue2LHNy2U0hw9gGQo2g
         grRD1JYYsHJ9THA6Y5HN5BRLedH1r0+QPVMD2hkk=
Date:   Thu, 24 Mar 2022 15:19:33 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny@suse.com>
Cc:     masami.ichikawa@cybertrust.co.jp, stable@vger.kernel.org,
        tj@kernel.org
Subject: Re: [PATCH 1/3] cgroup: Allocate cgroup_file_ctx for
 kernfs_open_file->priv
Message-ID: <Yjx99Uos49Mi9auv@kroah.com>
References: <YjseqrSJQd9412So@kroah.com>
 <20220323160102.3347-1-mkoutny@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20220323160102.3347-1-mkoutny@suse.com>
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Mar 23, 2022 at 05:01:00PM +0100, Michal Koutný wrote:
> From: Tejun Heo <tj@kernel.org>
> 
> commit 0d2b5955b36250a9428c832664f2079cbf723bec upstream.
> 
> of->priv is currently used by each interface file implementation to store
> private information. This patch collects the current two private data usages
> into struct cgroup_file_ctx which is allocated and freed by the common path.
> This allows generic private data which applies to multiple files, which will
> be used to in the following patch.
> 
> Note that cgroup_procs iterator is now embedded as procs.iter in the new
> cgroup_file_ctx so that it doesn't need to be allocated and freed
> separately.
> 
> v2: union dropped from cgroup_file_ctx and the procs iterator is embedded in
>     cgroup_file_ctx as suggested by Linus.
> 
> v3: Michal pointed out that cgroup1's procs pidlist uses of->priv too.
>     Converted. Didn't change to embedded allocation as cgroup1 pidlists get
>     stored for caching.
> 
> Signed-off-by: Tejun Heo <tj@kernel.org>
> Cc: Linus Torvalds <torvalds@linux-foundation.org>
> Reviewed-by: Michal Koutný <mkoutny@suse.com>
> [mkoutny: v5.10: modify cgroup.pressure handlers, adjust context]
> Signed-off-by: Michal Koutný <mkoutny@suse.com>
> ---

All now queued up, thanks.

greg k-h
