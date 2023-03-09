Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0B5C96B20EE
	for <lists+stable@lfdr.de>; Thu,  9 Mar 2023 11:07:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230021AbjCIKHm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 Mar 2023 05:07:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43416 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230033AbjCIKHl (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 9 Mar 2023 05:07:41 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 78CF1E4D84;
        Thu,  9 Mar 2023 02:07:39 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DF31961AD5;
        Thu,  9 Mar 2023 10:07:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD258C433EF;
        Thu,  9 Mar 2023 10:07:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678356458;
        bh=M2dk1uDWyM9XbA/9iJw/QbGme1KhQzfUYFQxVxzQLNk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=JEntjhVOJ04K6CT97BtONkVeDVHjzL2CtbAmnXWisaI+NrKTzZmcJfdgMcRD3dNIp
         HCM4sH+B6yA4khZP7RUNp/TmcT6MsSlS4p5gQLN9flG5nueU7mh2DUkebZ5pbvjYAB
         CJngoXl5/X9Y4OUrz6GADsSuQ1nTY8wscdWZuPXs=
Date:   Thu, 9 Mar 2023 11:07:35 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Sylvain Menu <sylvain.menu@gmail.com>
Cc:     stable@vger.kernel.org, regressions@lists.linux.dev,
        chuck.lever@oracle.com, jlayton@kernel.org,
        linux-nfs@vger.kernel.org
Subject: Re: nfs mount disappears due to inode revalidate failure
Message-ID: <ZAmv57xeNqs7v9hY@kroah.com>
References: <CACH9xG8-tEtWstUVmD9eZFEEAqx-E8Gs14wDL+=uNtBK=-KJvQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACH9xG8-tEtWstUVmD9eZFEEAqx-E8Gs14wDL+=uNtBK=-KJvQ@mail.gmail.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Mar 09, 2023 at 10:42:41AM +0100, Sylvain Menu wrote:
> Hello,
> 
> I am writing to report an issue on a nfs mount that disappears due to
> an inode revalide failure (already sent in January but probably banned
> with html format...).
> This very old commit
> (https://github.com/torvalds/linux/commit/cc89684c9a265828ce061037f1f79f4a68ccd3f7)
> exactly show the problem I have and this old resolved issue
> (https://bugzilla.kernel.org/show_bug.cgi?id=117651) is probably
> failing again today
> 
> To sum up, I have a NFS mount inside another NFS mount (for example:
> /opt/nfs/mount1 & /opt/nfs/mount1/mount2).
> If I kill a task trying to get a file descriptor on
> /opt/nfs/mount1/mount2 then it will be unmounted. My simple test code
> to reproduce very easily:
> 
> int main(int argc, char *argv[]) {
>     while (1) {
>         close(open(argv[1], O_RDONLY));
>     }
> }
> 
> In logs, I have: "nfs_revalidate_inode: (0:62/845965) getattr failed,
> error=-512"
> 
> Tested on 5.19 and 6.1 kernel

So is this a regression or something that has always been present?

thanks,

greg k-h
