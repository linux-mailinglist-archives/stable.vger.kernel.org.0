Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2649C27856
	for <lists+stable@lfdr.de>; Thu, 23 May 2019 10:45:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728277AbfEWIpy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 May 2019 04:45:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:60464 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725814AbfEWIpy (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 23 May 2019 04:45:54 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 47E0A20881;
        Thu, 23 May 2019 08:45:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1558601151;
        bh=7GHUIi6ELKMItFVqI1HiIEd+63yI9IuHQ0hoTD1S1tU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=KDsKKpifKxQ3fvBtWIFLv+dYK2q80WDwVcszVx0ydbK//GhWC67tyocqfK/qfCe7Q
         s4bc6Ehaa+E9SQsLCT1eYjqwTs7M7xk4MJoq+SBAvDFVetzdRN9EwIq4uuFXYqWI+P
         M9z+Dg43GW8CC5SDK6vYhAW4iBlgFma07ryJw1ZM=
Date:   Thu, 23 May 2019 10:45:49 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Lars Persson <lists@bofh.nu>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Ronnie Sahlberg <lsahlber@redhat.com>,
        Pavel Shilovsky <pshilov@microsoft.com>,
        Steve French <stfrench@microsoft.com>,
        Sasha Levin <alexander.levin@microsoft.com>
Subject: Re: [PATCH 4.14 082/115] cifs: fix memory leak in SMB2_read
Message-ID: <20190523084549.GC6670@kroah.com>
References: <20190515090659.123121100@linuxfoundation.org>
 <20190515090705.305124547@linuxfoundation.org>
 <CADnJP=v8Zn7dr11_KXFSWPwMtEc-rPTgFcRsbRy1mnBL5uDHvg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CADnJP=v8Zn7dr11_KXFSWPwMtEc-rPTgFcRsbRy1mnBL5uDHvg@mail.gmail.com>
User-Agent: Mutt/1.11.4 (2019-03-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, May 23, 2019 at 09:53:31AM +0200, Lars Persson wrote:
> On Wed, May 15, 2019 at 1:19 PM Greg Kroah-Hartman
> <gregkh@linuxfoundation.org> wrote:
> >
> > [ Upstream commit 05fd5c2c61732152a6bddc318aae62d7e436629b ]
> >
> > Commit 088aaf17aa79300cab14dbee2569c58cfafd7d6e introduced a leak where
> > if SMB2_read() returned an error we would return without freeing the
> > request buffer.
> >
> > Cc: Stable <stable@vger.kernel.org>
> > Signed-off-by: Ronnie Sahlberg <lsahlber@redhat.com>
> > Reviewed-by: Pavel Shilovsky <pshilov@microsoft.com>
> > Signed-off-by: Steve French <stfrench@microsoft.com>
> > Signed-off-by: Sasha Levin <alexander.levin@microsoft.com>
> > ---
> >  fs/cifs/smb2pdu.c | 1 +
> >  1 file changed, 1 insertion(+)
> >
> > diff --git a/fs/cifs/smb2pdu.c b/fs/cifs/smb2pdu.c
> > index fd2d199dd413e..7936eac5a38a2 100644
> > --- a/fs/cifs/smb2pdu.c
> > +++ b/fs/cifs/smb2pdu.c
> > @@ -2699,6 +2699,7 @@ SMB2_read(const unsigned int xid, struct cifs_io_parms *io_parms,
> >                         cifs_dbg(VFS, "Send error in read = %d\n", rc);
> >                 }
> >                 free_rsp_buf(resp_buftype, rsp_iov.iov_base);
> > +               cifs_small_buf_release(req);
> >                 return rc == -ENODATA ? 0 : rc;
> >         }
> >
> > --
> > 2.20.1
> >
> 
> This patch should not be in 4.14-stable because
> 088aaf17aa79300cab14dbee2569c58cfafd7d6e was for 4.18+.
> 
> Now we have a double-free crash in SMB2_read because there are 2 calls
> to cifs_small_buf_release in the error path.
> 
> =============================================================================
> BUG cifs_small_rq (Tainted: G    B      O   ): Object already free
> -----------------------------------------------------------------------------
> 
> INFO: Allocated in mempool_alloc+0x35/0xe4 age=1 cpu=0 pid=21107
> kmem_cache_alloc+0x131/0x218
> mempool_alloc+0x35/0xe4
> cifs_small_buf_get+0x1d/0x3c [cifs]
> smb2_new_read_req.constprop.2+0x29/0xd0 [cifs]
> SMB2_read+0x39/0x17c [cifs]
> cifs_readpage_worker+0x13f/0x470 [cifs]
> cifs_readpage+0x67/0x1b8 [cifs]
> generic_file_read_iter+0x269/0x904
> cifs_strict_readv+0xa3/0xc8 [cifs]
> __vfs_read+0x97/0xbc
> vfs_read+0x61/0xc8
> SyS_pread64+0x4d/0x6c
> ret_fast_syscall+0x1/0x64
> INFO: Freed in cifs_small_buf_release+0x19/0x90 [cifs] age=0 cpu=0 pid=21107
> cifs_small_buf_release+0x19/0x90 [cifs]
> SMB2_read+0x83/0x17c [cifs]
> cifs_readpage_worker+0x13f/0x470 [cifs]
> cifs_readpage+0x67/0x1b8 [cifs]
> generic_file_read_iter+0x269/0x904
> cifs_strict_readv+0xa3/0xc8 [cifs]
> __vfs_read+0x97/0xbc
> vfs_read+0x61/0xc8
> SyS_pread64+0x4d/0x6c
> ret_fast_syscall+0x1/0x64
> INFO: Slab 0xbf6fe800 objects=12 used=1 fp=0x8cf00d40 flags=0x8101
> INFO: Object 0x8cf01d00 @offset=7424 fp=0x8cf002c0
> 
> Redzone 8cf01ce0: bb bb bb bb bb bb bb bb bb bb bb bb bb bb bb bb
> ................
> Redzone 8cf01cf0: bb bb bb bb bb bb bb bb bb bb bb bb bb bb bb bb
> ................
> Object 8cf01d00: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b
> kkkkkkkkkkkkkkkk
> Object 8cf01d10: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b
> kkkkkkkkkkkkkkkk
> Object 8cf01d20: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b
> kkkkkkkkkkkkkkkk
> Object 8cf01d30: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b
> kkkkkkkkkkkkkkkk
> Object 8cf01d40: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b
> kkkkkkkkkkkkkkkk
> Object 8cf01d50: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b
> kkkkkkkkkkkkkkkk
> Object 8cf01d60: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b
> kkkkkkkkkkkkkkkk
> Object 8cf01d70: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b
> kkkkkkkkkkkkkkkk
> Object 8cf01d80: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b
> kkkkkkkkkkkkkkkk
> Object 8cf01d90: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b
> kkkkkkkkkkkkkkkk
> Object 8cf01da0: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b
> kkkkkkkkkkkkkkkk
> Object 8cf01db0: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b
> kkkkkkkkkkkkkkkk
> Object 8cf01dc0: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b
> kkkkkkkkkkkkkkkk
> Object 8cf01dd0: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b
> kkkkkkkkkkkkkkkk
> Object 8cf01de0: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b
> kkkkkkkkkkkkkkkk
> Object 8cf01df0: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b
> kkkkkkkkkkkkkkkk
> Object 8cf01e00: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b
> kkkkkkkkkkkkkkkk
> Object 8cf01e10: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b
> kkkkkkkkkkkkkkkk
> Object 8cf01e20: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b
> kkkkkkkkkkkkkkkk
> Object 8cf01e30: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b
> kkkkkkkkkkkkkkkk
> Object 8cf01e40: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b
> kkkkkkkkkkkkkkkk
> Object 8cf01e50: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b
> kkkkkkkkkkkkkkkk
> Object 8cf01e60: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b
> kkkkkkkkkkkkkkkk
> Object 8cf01e70: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b
> kkkkkkkkkkkkkkkk
> Object 8cf01e80: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b
> kkkkkkkkkkkkkkkk
> Object 8cf01e90: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b
> kkkkkkkkkkkkkkkk
> Object 8cf01ea0: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b
> kkkkkkkkkkkkkkkk
> Object 8cf01eb0: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b a5
> kkkkkkkkkkkkkkk.
> Redzone 8cf01ec0: bb bb bb bb                                      ....
> Padding 8cf01f68: 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a
> ZZZZZZZZZZZZZZZZ
> Padding 8cf01f78: 5a 5a 5a 5a 5a 5a 5a 5a                          ZZZZZZZZ
> CPU: 0 PID: 21107 Comm: pool-indexer Tainted: G    B      O
> 4.14.120-axis5-devel #1
> Hardware name: Axis ARTPEC-7 Platform
> [<8010d031>] (unwind_backtrace) from [<80109f21>] (show_stack+0x11/0x14)
> [<80109f21>] (show_stack) from [<8051e1d1>] (dump_stack+0x69/0x78)
> [<8051e1d1>] (dump_stack) from [<802179cd>] (free_debug_processing+0x289/0x2b4)
> [<802179cd>] (free_debug_processing) from [<80217b81>] (__slab_free+0x189/0x26c)
> [<80217b81>] (__slab_free) from [<80217dc5>] (kmem_cache_free+0x161/0x1ec)
> [<80217dc5>] (kmem_cache_free) from [<7fad04c1>]
> (cifs_small_buf_release+0x19/0x90 [cifs])
> [<7fad04c1>] (cifs_small_buf_release [cifs]) from [<7fae1e43>]
> (SMB2_read+0xd3/0x17c [cifs])
> [<7fae1e43>] (SMB2_read [cifs]) from [<7fac5aeb>]
> (cifs_readpage_worker+0x13f/0x470 [cifs])
> [<7fac5aeb>] (cifs_readpage_worker [cifs]) from [<7fac6127>]
> (cifs_readpage+0x67/0x1b8 [cifs])
> [<7fac6127>] (cifs_readpage [cifs]) from [<801dc855>]
> (generic_file_read_iter+0x269/0x904)
> [<801dc855>] (generic_file_read_iter) from [<7facb193>]
> (cifs_strict_readv+0xa3/0xc8 [cifs])
> [<7facb193>] (cifs_strict_readv [cifs]) from [<8022855f>] (__vfs_read+0x97/0xbc)
> [<8022855f>] (__vfs_read) from [<802285e5>] (vfs_read+0x61/0xc8)
> [<802285e5>] (vfs_read) from [<80228a4d>] (SyS_pread64+0x4d/0x6c)
> [<80228a4d>] (SyS_pread64) from [<80106d81>] (ret_fast_syscall+0x1/0x64)
> FIX cifs_small_rq: Object at 0x8cf01d00 not freed

Ah, my fault, thanks for letting me know.  I'll go revert this right
now.

thanks,

greg k-h
