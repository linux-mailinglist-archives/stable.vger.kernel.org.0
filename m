Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EA2503F3017
	for <lists+stable@lfdr.de>; Fri, 20 Aug 2021 17:49:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241265AbhHTPuQ convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Fri, 20 Aug 2021 11:50:16 -0400
Received: from eu-smtp-delivery-151.mimecast.com ([185.58.86.151]:54135 "EHLO
        eu-smtp-delivery-151.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S241303AbhHTPuG (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 20 Aug 2021 11:50:06 -0400
Received: from AcuMS.aculab.com (156.67.243.121 [156.67.243.121]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 uk-mta-131-DAGKzonBN4SYNa4fYJu3Dw-1; Fri, 20 Aug 2021 16:49:23 +0100
X-MC-Unique: DAGKzonBN4SYNa4fYJu3Dw-1
Received: from AcuMS.Aculab.com (fd9f:af1c:a25b:0:994c:f5c2:35d6:9b65) by
 AcuMS.aculab.com (fd9f:af1c:a25b:0:994c:f5c2:35d6:9b65) with Microsoft SMTP
 Server (TLS) id 15.0.1497.23; Fri, 20 Aug 2021 16:49:22 +0100
Received: from AcuMS.Aculab.com ([fe80::994c:f5c2:35d6:9b65]) by
 AcuMS.aculab.com ([fe80::994c:f5c2:35d6:9b65%12]) with mapi id
 15.00.1497.023; Fri, 20 Aug 2021 16:49:22 +0100
From:   David Laight <David.Laight@ACULAB.COM>
To:     'Jeff Layton' <jlayton@kernel.org>,
        "torvalds@linux-foundation.org" <torvalds@linux-foundation.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC:     "ebiederm@xmission.com" <ebiederm@xmission.com>,
        "david@redhat.com" <david@redhat.com>,
        "willy@infradead.org" <willy@infradead.org>,
        "linux-nfs@vger.kernel.org" <linux-nfs@vger.kernel.org>,
        "viro@zeniv.linux.org.uk" <viro@zeniv.linux.org.uk>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "v9fs-developer@lists.sourceforge.net" 
        <v9fs-developer@lists.sourceforge.net>,
        "linux-afs@lists.infradead.org" <linux-afs@lists.infradead.org>,
        "cluster-devel@redhat.com" <cluster-devel@redhat.com>,
        "ocfs2-devel@oss.oracle.com" <ocfs2-devel@oss.oracle.com>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "luto@kernel.org" <luto@kernel.org>,
        "bfields@fieldses.org" <bfields@fieldses.org>,
        "w@1wt.eu" <w@1wt.eu>, "rostedt@goodmis.org" <rostedt@goodmis.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: RE: [PATCH v2 1/2] fs: warn about impending deprecation of mandatory
 locks
Thread-Topic: [PATCH v2 1/2] fs: warn about impending deprecation of mandatory
 locks
Thread-Index: AQHXlctJ2CxbK7rVbku/gUAYi8DQHat8icSQ
Date:   Fri, 20 Aug 2021 15:49:22 +0000
Message-ID: <c1318459eaab436aacb225982c49c4b4@AcuMS.aculab.com>
References: <20210820135707.171001-1-jlayton@kernel.org>
 <20210820135707.171001-2-jlayton@kernel.org>
In-Reply-To: <20210820135707.171001-2-jlayton@kernel.org>
Accept-Language: en-GB, en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [10.202.205.107]
MIME-Version: 1.0
Authentication-Results: relay.mimecast.com;
        auth=pass smtp.auth=C51A453 smtp.mailfrom=david.laight@aculab.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: aculab.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jeff Layton
> Sent: 20 August 2021 14:57
> 
> We've had CONFIG_MANDATORY_FILE_LOCKING since 2015 and a lot of distros
> have disabled it. Warn the stragglers that still use "-o mand" that
> we'll be dropping support for that mount option.
> 
> Cc: stable@vger.kernel.org
> Signed-off-by: Jeff Layton <jlayton@kernel.org>
> ---
>  fs/namespace.c | 8 ++++++++
>  1 file changed, 8 insertions(+)
> 
> diff --git a/fs/namespace.c b/fs/namespace.c
> index ab4174a3c802..ffab0bb1e649 100644
> --- a/fs/namespace.c
> +++ b/fs/namespace.c
> @@ -1716,8 +1716,16 @@ static inline bool may_mount(void)
>  }
> 
>  #ifdef	CONFIG_MANDATORY_FILE_LOCKING
> +static bool warned_mand;
>  static inline bool may_mandlock(void)
>  {
> +	if (!warned_mand) {
> +		warned_mand = true;
> +		pr_warn("======================================================\n");
> +		pr_warn("WARNING: the mand mount option is being deprecated and\n");
> +		pr_warn("         will be removed in v5.15!\n");
> +		pr_warn("======================================================\n");
> +	}
>  	return capable(CAP_SYS_ADMIN);
>  }

If that is called more than once you don't want the 'inline'.
I doubt it matters is not inlined - hardly a hot path.

	David

-
Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1PT, UK
Registration No: 1397386 (Wales)

