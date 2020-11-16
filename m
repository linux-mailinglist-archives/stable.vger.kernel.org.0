Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8107A2B3F24
	for <lists+stable@lfdr.de>; Mon, 16 Nov 2020 09:52:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728291AbgKPIwW convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Mon, 16 Nov 2020 03:52:22 -0500
Received: from frasgout.his.huawei.com ([185.176.79.56]:2104 "EHLO
        frasgout.his.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726969AbgKPIwW (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Nov 2020 03:52:22 -0500
Received: from fraeml702-chm.china.huawei.com (unknown [172.18.147.201])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4CZN7s3tFrz67DF4;
        Mon, 16 Nov 2020 16:50:33 +0800 (CST)
Received: from fraeml714-chm.china.huawei.com (10.206.15.33) by
 fraeml702-chm.china.huawei.com (10.206.15.51) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.1913.5; Mon, 16 Nov 2020 09:52:19 +0100
Received: from fraeml714-chm.china.huawei.com ([10.206.15.33]) by
 fraeml714-chm.china.huawei.com ([10.206.15.33]) with mapi id 15.01.1913.007;
 Mon, 16 Nov 2020 09:52:19 +0100
From:   Roberto Sassu <roberto.sassu@huawei.com>
To:     Christoph Hellwig <hch@infradead.org>
CC:     "zohar@linux.ibm.com" <zohar@linux.ibm.com>,
        "linux-integrity@vger.kernel.org" <linux-integrity@vger.kernel.org>,
        "linux-security-module@vger.kernel.org" 
        <linux-security-module@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Silviu Vlasceanu <Silviu.Vlasceanu@huawei.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "torvalds@linux-foundation.org" <torvalds@linux-foundation.org>,
        "viro@zeniv.linux.org.uk" <viro@zeniv.linux.org.uk>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>
Subject: RE: [RESEND][PATCH] ima: Set and clear FMODE_CAN_READ in
 ima_calc_file_hash()
Thread-Topic: [RESEND][PATCH] ima: Set and clear FMODE_CAN_READ in
 ima_calc_file_hash()
Thread-Index: AQHWuZM+vbqfejrqe02000rC0h3xoqnHabyAgAMLzKA=
Date:   Mon, 16 Nov 2020 08:52:19 +0000
Message-ID: <0fd0fb3360194d909ba48f13220f9302@huawei.com>
References: <20201113080132.16591-1-roberto.sassu@huawei.com>
 <20201114111057.GA16415@infradead.org>
In-Reply-To: <20201114111057.GA16415@infradead.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.220.96.108]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

> From: Christoph Hellwig [mailto:hch@infradead.org]
> Sent: Saturday, November 14, 2020 12:11 PM
> On Fri, Nov 13, 2020 at 09:01:32AM +0100, Roberto Sassu wrote:
> > Commit a1f9b1c0439db ("integrity/ima: switch to using __kernel_read")
> > replaced the __vfs_read() call in integrity_kernel_read() with
> > __kernel_read(), a new helper introduced by commit 61a707c543e2a ("fs:
> add
> > a __kernel_read helper").
> >
> > Since the new helper requires that also the FMODE_CAN_READ flag is set
> in
> > file->f_mode, this patch saves the original f_mode and sets the flag if the
> > the file descriptor has the necessary file operation. Lastly, it restores
> > the original f_mode at the end of ima_calc_file_hash().
> 
> This looks bogus.  FMODE_CAN_READ has a pretty clear definition and
> you can't just go and read things if it is not set.  Also f_mode
> manipulations on a life file are racy.

FMODE_CAN_READ was not set because f_mode does not have
FMODE_READ. In the patch, I check if the former can be set
similarly to the way it is done in file_table.c and open.c.

Is there a better way to read a file when the file was not opened
for reading and a new file descriptor cannot be created?

Thanks

Roberto

HUAWEI TECHNOLOGIES Duesseldorf GmbH, HRB 56063
Managing Director: Li Peng, Li Jian, Shi Yanli

> > Cc: stable@vger.kernel.org # 5.8.x
> > Fixes: a1f9b1c0439db ("integrity/ima: switch to using __kernel_read")
> > Signed-off-by: Roberto Sassu <roberto.sassu@huawei.com>
> > ---
> >  security/integrity/ima/ima_crypto.c | 8 ++++++--
> >  1 file changed, 6 insertions(+), 2 deletions(-)
> >
> > diff --git a/security/integrity/ima/ima_crypto.c
> b/security/integrity/ima/ima_crypto.c
> > index 21989fa0c107..22ed86a0c964 100644
> > --- a/security/integrity/ima/ima_crypto.c
> > +++ b/security/integrity/ima/ima_crypto.c
> > @@ -537,6 +537,7 @@ int ima_calc_file_hash(struct file *file, struct
> ima_digest_data *hash)
> >  	loff_t i_size;
> >  	int rc;
> >  	struct file *f = file;
> > +	fmode_t saved_mode;
> >  	bool new_file_instance = false, modified_mode = false;
> >
> >  	/*
> > @@ -550,7 +551,7 @@ int ima_calc_file_hash(struct file *file, struct
> ima_digest_data *hash)
> >  	}
> >
> >  	/* Open a new file instance in O_RDONLY if we cannot read */
> > -	if (!(file->f_mode & FMODE_READ)) {
> > +	if (!(file->f_mode & FMODE_READ) || !(file->f_mode &
> FMODE_CAN_READ)) {
> >  		int flags = file->f_flags & ~(O_WRONLY | O_APPEND |
> >  				O_TRUNC | O_CREAT | O_NOCTTY |
> O_EXCL);
> >  		flags |= O_RDONLY;
> > @@ -562,7 +563,10 @@ int ima_calc_file_hash(struct file *file, struct
> ima_digest_data *hash)
> >  			 */
> >  			pr_info_ratelimited("Unable to reopen file for
> reading.\n");
> >  			f = file;
> > +			saved_mode = f->f_mode;
> >  			f->f_mode |= FMODE_READ;
> > +			if (likely(file->f_op->read || file->f_op->read_iter))
> > +				f->f_mode |= FMODE_CAN_READ;
> >  			modified_mode = true;
> >  		} else {
> >  			new_file_instance = true;
> > @@ -582,7 +586,7 @@ int ima_calc_file_hash(struct file *file, struct
> ima_digest_data *hash)
> >  	if (new_file_instance)
> >  		fput(f);
> >  	else if (modified_mode)
> > -		f->f_mode &= ~FMODE_READ;
> > +		f->f_mode = saved_mode;
> >  	return rc;
> >  }
> >
> > --
> > 2.27.GIT
> >
> ---end quoted text---
