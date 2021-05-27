Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3F2CE392B27
	for <lists+stable@lfdr.de>; Thu, 27 May 2021 11:51:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235809AbhE0JxV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 May 2021 05:53:21 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:49503 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235724AbhE0JxV (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 27 May 2021 05:53:21 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1622109108;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=u9Cxtk2CGDavcxRvdG5xqMXG/D6DQ86Gj3Jra0Du2iA=;
        b=JoscmxOsBQCWDPPaE0kZojQUtPyZR6xxmzZUk63GuyX+vEznZhfvRVp6cD0VGRDMS0e7gE
        AMYwxDUHjjggEGNhrasB+oJQbMHIs77MHwqhqwna8HfDH+BogHfZ86JZsF363DGSGXZokY
        LCaZvPIq8XOFkxb9x6geIDOKKkt2vN4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-276-H_O0Ks53PH6uw7WYjNETzA-1; Thu, 27 May 2021 05:51:46 -0400
X-MC-Unique: H_O0Ks53PH6uw7WYjNETzA-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 28388101371B;
        Thu, 27 May 2021 09:51:45 +0000 (UTC)
Received: from dresden.str.redhat.com (ovpn-114-232.ams2.redhat.com [10.36.114.232])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 873B3687D7;
        Thu, 27 May 2021 09:51:39 +0000 (UTC)
Subject: Re: [Virtio-fs] [PATCH 1/4] fuse: Fix crash in
 fuse_dentry_automount() error path
To:     Greg Kurz <groug@kaod.org>, Miklos Szeredi <miklos@szeredi.hu>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        virtio-fs@redhat.com, linux-fsdevel@vger.kernel.org,
        Vivek Goyal <vgoyal@redhat.com>
References: <20210525150230.157586-1-groug@kaod.org>
 <20210525150230.157586-2-groug@kaod.org>
From:   Max Reitz <mreitz@redhat.com>
Message-ID: <cef80ba1-b0c1-a8bd-387a-9c7d2730a766@redhat.com>
Date:   Thu, 27 May 2021 11:51:37 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20210525150230.157586-2-groug@kaod.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 25.05.21 17:02, Greg Kurz wrote:
> If fuse_fill_super_submount() returns an error, the error path
> triggers a crash:
> 
> [   26.206673] BUG: kernel NULL pointer dereference, address: 0000000000000000
> [...]
> [   26.226362] RIP: 0010:__list_del_entry_valid+0x25/0x90
> [...]
> [   26.247938] Call Trace:
> [   26.248300]  fuse_mount_remove+0x2c/0x70 [fuse]
> [   26.248892]  virtio_kill_sb+0x22/0x160 [virtiofs]
> [   26.249487]  deactivate_locked_super+0x36/0xa0
> [   26.250077]  fuse_dentry_automount+0x178/0x1a0 [fuse]
> 
> The crash happens because fuse_mount_remove() assumes that the FUSE
> mount was already added to list under the FUSE connection, but this
> only done after fuse_fill_super_submount() has returned success.
> 
> This means that until fuse_fill_super_submount() has returned success,
> the FUSE mount isn't actually owned by the superblock. We should thus
> reclaim ownership by clearing sb->s_fs_info, which will skip the call
> to fuse_mount_remove(), and perform rollback, like virtio_fs_get_tree()
> already does for the root sb.
> 
> Fixes: bf109c64040f ("fuse: implement crossmounts")
> Cc: mreitz@redhat.com
> Cc: stable@vger.kernel.org # v5.10+
> Signed-off-by: Greg Kurz <groug@kaod.org>
> ---
>   fs/fuse/dir.c | 6 +++++-
>   1 file changed, 5 insertions(+), 1 deletion(-)

Reviewed-by: Max Reitz <mreitz@redhat.com>

