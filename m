Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8DD3060FB13
	for <lists+stable@lfdr.de>; Thu, 27 Oct 2022 17:02:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229645AbiJ0PCW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 Oct 2022 11:02:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42238 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235392AbiJ0PCU (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 27 Oct 2022 11:02:20 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E601B18DD5D
        for <stable@vger.kernel.org>; Thu, 27 Oct 2022 08:02:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9522FB8268D
        for <stable@vger.kernel.org>; Thu, 27 Oct 2022 15:02:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C0D85C433D6;
        Thu, 27 Oct 2022 15:02:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666882937;
        bh=G5aiIhys9A6CiTEfd7pRYmQIhSrI497W3TOcT1Eaj4Y=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=HI9zBQp9xuVwwpXbGK2FPmBRIKkPFhZ9jH2tp55uHzowv7cJWxhXs7Mbx73Nr/aks
         ol92wgH8eQMe0k+/negZ8kxs9dz5NXDf8J1Sg0kdelpzd5HCI93pcscJUqeQOxVLHK
         f2v3YxcmyJy0Q8B1ujhF2ZQVhfMNDt0SNMFQXdDQ=
Date:   Thu, 27 Oct 2022 17:02:14 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Jiri Olsa <olsajiri@gmail.com>
Cc:     Dominique Martinet <asmadeus@codewreck.org>,
        stable@vger.kernel.org,
        Martin Rodriguez Reboredo <yakoyoku@gmail.com>,
        Andrii Nakryiko <andrii@kernel.org>
Subject: Re: [PATCH 5.10] kbuild: fix BTF build with pahole 1.24
Message-ID: <Y1qddouJLYV0wlNw@kroah.com>
References: <20221027120158.2791406-1-asmadeus@codewreck.org>
 <Y1qAh6TzBw4b3+TQ@krava>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y1qAh6TzBw4b3+TQ@krava>
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Oct 27, 2022 at 02:58:47PM +0200, Jiri Olsa wrote:
> On Thu, Oct 27, 2022 at 09:01:58PM +0900, Dominique Martinet wrote:
> > pahole 1.24 broke builds on kernel <6.0 which do not have the
> > new BTF_KIND_ENUM64 BTF tag.
> > The 5.15 branch fixed this in commit b775fbf532dc01ae53a6fc56168fd30cb4b0c658
> > ("kbuild: Add skip_encoding_btf_enum64 option to pahole"), which
> > we cannot use directly for 5.10 because 5.10 does not have the
> > pahole-flags.sh script, itself introduced in upstream commit
> > 0baced0e0938f2895ceba54038eaf15ed91032e7 ("kbuild: Unify options
> > for BTF generation for vmlinux and modules")
> > 
> > that last commit is difficult to backport as 5.10 does not have BTF
> > for modules support: work around the problem by just copying the
> > pahole-flags.sh script and calling it directly in link-vmlinux.sh,
> > which is hopefully acceptable as the flags are not shared in this tree.
> > 
> > Note that compared to 5.15 the flags script does not have
> > --btf_gen_floats as linux 5.10 did not have that BTF tag yet;
> > but any new flag added to 5.15 will not be able to be added to 5.10 in
> > an identical way for any future breakage.
> > 
> > Cc: Martin Rodriguez Reboredo <yakoyoku@gmail.com>
> > Cc: Jiri Olsa <jolsa@kernel.org>
> > CC: Andrii Nakryiko <andrii@kernel.org>
> > Signed-off-by: Dominique Martinet <asmadeus@codewreck.org>
> 
> hi,
> I sent this backport just recently:
>   https://lore.kernel.org/bpf/Y1lkASXgeW0jfP8o@kroah.com/T/#t
> 
> it's split into several patches, hopefuly fixing the issue for you

Yes, this should be resolved in the next 5.10.y release.

thanks,

greg k-h
