Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4AB673426E
	for <lists+stable@lfdr.de>; Tue,  4 Jun 2019 10:57:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727033AbfFDI5Y (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 4 Jun 2019 04:57:24 -0400
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:48840 "EHLO
        bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726927AbfFDI5Y (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 4 Jun 2019 04:57:24 -0400
Received: from localhost (localhost [127.0.0.1])
        by bedivere.hansenpartnership.com (Postfix) with ESMTP id 1ABE08EE1D8;
        Tue,  4 Jun 2019 01:57:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=hansenpartnership.com;
        s=20151216; t=1559638644;
        bh=wI/8+wiijGgOqLSYHFzdmNaGRkSygv9a+oR+A5uQbEQ=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=rfb3INXuVy4qOBudIOjCKyAXVMI684m+PxHEGeKwMGmp8gEHXGZRA6JyeEUZ9c0/H
         e5CXWketma7GjLRupwrcYJuK0Nxl5pnqMZPaALWCUjCi1h3sMe7r/PfGIwTfBtzB5W
         b2aD8n3OoevNwekKzuL3YRh6eZ3F2lB83HOGoqEI=
Received: from bedivere.hansenpartnership.com ([127.0.0.1])
        by localhost (bedivere.hansenpartnership.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id vVbUH0cOyB66; Tue,  4 Jun 2019 01:57:23 -0700 (PDT)
Received: from jarvis.guest.haifa.ibm.com (unknown [195.110.41.42])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by bedivere.hansenpartnership.com (Postfix) with ESMTPSA id 8921B8EE101;
        Tue,  4 Jun 2019 01:57:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=hansenpartnership.com;
        s=20151216; t=1559638643;
        bh=wI/8+wiijGgOqLSYHFzdmNaGRkSygv9a+oR+A5uQbEQ=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=xUN9j1ybZGq/0Fl2pBKJHXRrazk9uYYwC16X//yILiBdGZMFtElgxzDbIW10F1dGI
         EPTJZ1M2kM6L9rgoiph1CxRKJoIr2ylDIAJE3kej12ObHS2hd/gghg2HghWz8WO5bW
         WhQt5hGy8hYOjB3EkU8u9iFo2QeiMmgNL4x3WP4Q=
Message-ID: <1559638637.3410.3.camel@HansenPartnership.com>
Subject: Re: [PATCH v2 2/3] ima: don't ignore INTEGRITY_UNKNOWN EVM status
From:   James Bottomley <James.Bottomley@HansenPartnership.com>
To:     Roberto Sassu <roberto.sassu@huawei.com>,
        Mimi Zohar <zohar@linux.ibm.com>, dmitry.kasatkin@huawei.com,
        mjg59@google.com
Cc:     linux-integrity@vger.kernel.org,
        linux-security-module@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, silviu.vlasceanu@huawei.com,
        stable@vger.kernel.org
Date:   Tue, 04 Jun 2019 11:57:17 +0300
In-Reply-To: <b38d75b1-873a-1630-0148-41c49571531a@huawei.com>
References: <20190529133035.28724-1-roberto.sassu@huawei.com>
         <20190529133035.28724-3-roberto.sassu@huawei.com>
         <1559217621.4008.7.camel@linux.ibm.com>
         <e6b31aa9-0319-1805-bdfc-3ddde5884494@huawei.com>
         <1559569401.5052.17.camel@HansenPartnership.com>
         <3667fbd4-b6ed-6a76-9ff4-84ec3c2dda12@huawei.com>
         <1559572305.5052.19.camel@HansenPartnership.com>
         <b38d75b1-873a-1630-0148-41c49571531a@huawei.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.26.6 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 2019-06-03 at 16:44 +0200, Roberto Sassu wrote:
> On 6/3/2019 4:31 PM, James Bottomley wrote:
> > On Mon, 2019-06-03 at 16:29 +0200, Roberto Sassu wrote:
[...]
> > > How would you prevent root in the container from updating
> > > security.ima?
> > 
> > We don't.  We only guarantee immutability for unprivileged
> > containers, so root can't be inside.
> 
> Ok.
> 
> Regarding the new behavior, this must be explicitly enabled by adding
> ima_appraise=enforce-evm or log-evm to the kernel command line.
> Otherwise, the current behavior is preserved with this patch. Would
> this be ok?

Sure, as long as it's an opt-in flag, meaning the behaviour of my
kernels on physical cloud systems doesn't change as I upgrade them, I'm
fine with that.

James

