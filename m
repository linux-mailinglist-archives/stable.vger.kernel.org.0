Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1DF5E523551
	for <lists+stable@lfdr.de>; Wed, 11 May 2022 16:24:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236034AbiEKOYT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 11 May 2022 10:24:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49620 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244576AbiEKOXw (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 11 May 2022 10:23:52 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 04034644C4;
        Wed, 11 May 2022 07:23:50 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A9DC7B82410;
        Wed, 11 May 2022 14:23:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 218DDC34114;
        Wed, 11 May 2022 14:23:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1652279027;
        bh=xF1wpfNlloh/wJleTtO8bYNgIpZtkV/b7QnypXCRSpQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=cPFVs+7dlK+KZt/5RP1ufVVakMPtd6o5p0dVn0LnQ79u3LmDnt0M9U1787VUs9254
         Y3HS7wxa6svv4acqJBz9pr8cN8AMo2hJ0XBhp4GIrBEM7uIwOn3BVUcMCL4wcx+Bfb
         oZPxHSvtv6NPaa2DxLUaF9WoWilB4TDVX4BavY68=
Date:   Wed, 11 May 2022 16:23:43 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Chuck Lever III <chuck.lever@oracle.com>
Cc:     Wolfgang Walter <linux@stwm.de>,
        linux-stable <stable@vger.kernel.org>,
        Trond Myklebust <trondmy@gmail.com>,
        Linux NFS Mailing List <linux-nfs@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: 5.4.188 and later: massive performance regression with nfsd
Message-ID: <YnvG71v4Ay560D+X@kroah.com>
References: <f8d9b9112607df4807fba8948ac6e145@stwm.de>
 <YnuuLZe6h80KCNhd@kroah.com>
 <6A15DEE1-CAC9-4C64-8643-AD28EA423046@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6A15DEE1-CAC9-4C64-8643-AD28EA423046@oracle.com>
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, May 11, 2022 at 02:16:19PM +0000, Chuck Lever III wrote:
> 
> 
> > On May 11, 2022, at 8:38 AM, Greg KH <gregkh@linuxfoundation.org> wrote:
> > 
> > On Wed, May 11, 2022 at 12:03:13PM +0200, Wolfgang Walter wrote:
> >> Hi,
> >> 
> >> starting with 5.4.188 wie see a massive performance regression on our
> >> nfs-server. It basically is serving requests very very slowly with cpu
> >> utilization of 100% (with 5.4.187 and earlier it is 10%) so that it is
> >> unusable as a fileserver.
> >> 
> >> The culprit are commits (or one of it):
> >> 
> >> c32f1041382a88b17da5736886da4a492353a1bb "nfsd: cleanup
> >> nfsd_file_lru_dispose()"
> >> 628adfa21815f74c04724abc85847f24b5dd1645 "nfsd: Containerise filecache
> >> laundrette"
> >> 
> >> (upstream 36ebbdb96b694dd9c6b25ad98f2bbd263d022b63 and
> >> 9542e6a643fc69d528dfb3303f145719c61d3050)
> >> 
> >> If I revert them in v5.4.192 the kernel works as before and performance is
> >> ok again.
> >> 
> >> I did not try to revert them one by one as any disruption of our nfs-server
> >> is a severe problem for us and I'm not sure if they are related.
> >> 
> >> 5.10 and 5.15 both always performed very badly on our nfs-server in a
> >> similar way so we were stuck with 5.4.
> >> 
> >> I now think this is because of 36ebbdb96b694dd9c6b25ad98f2bbd263d022b63
> >> and/or 9542e6a643fc69d528dfb3303f145719c61d3050 though I didn't tried to
> >> revert them in 5.15 yet.
> > 
> > Odds are 5.18-rc6 is also a problem?
> 
> We believe that
> 
> 6b8a94332ee4 ("nfsd: Fix a write performance regression")
> 
> addresses the performance regression. It was merged into 5.18-rc.

And into 5.17.4 if someone wants to try that release.

> > If so, I'll just wait for the fix to get into Linus's tree as this does
> > not seem to be a stable-tree-only issue.
> 
> Unfortunately I've received a recent report that the fix introduces
> a "sleep while spinlock is held" for NFSv4.0 in rare cases.

Ick, not good, any potential fixes for that?

thanks,

greg k-h
