Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 533EF30CF89
	for <lists+stable@lfdr.de>; Wed,  3 Feb 2021 00:01:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232733AbhBBXBR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 2 Feb 2021 18:01:17 -0500
Received: from bedivere.hansenpartnership.com ([96.44.175.130]:53234 "EHLO
        bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235023AbhBBXBQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 2 Feb 2021 18:01:16 -0500
Received: from localhost (localhost [127.0.0.1])
        by bedivere.hansenpartnership.com (Postfix) with ESMTP id 1349D1280913;
        Tue,  2 Feb 2021 15:00:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
        d=hansenpartnership.com; s=20151216; t=1612306836;
        bh=NegTp8fookjQYG6nvXxAhnEsy5s1BaHZMwSCW3Xa9wM=;
        h=Message-ID:Subject:From:To:Date:In-Reply-To:References:From;
        b=CLBpmDNFXEy3e7sM9SzOKgXbxkFEVUXUDtMIsbBm0vHjno9lGgA50q5DJN8lX1rLY
         zmzVljTn1/uwFAQ6VEOxizE7SySKhCjfGh1XuSnOgbCRd/at7cuPllFotG8TgHHZV/
         Vz+m2eh27COgoocqqBJeKe+UxSJlu59xvfcHAOLQ=
Received: from bedivere.hansenpartnership.com ([127.0.0.1])
        by localhost (bedivere.hansenpartnership.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id OCDZYzCJm-hi; Tue,  2 Feb 2021 15:00:36 -0800 (PST)
Received: from jarvis.int.hansenpartnership.com (unknown [IPv6:2601:600:8280:66d1::c447])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by bedivere.hansenpartnership.com (Postfix) with ESMTPSA id 736A8128090D;
        Tue,  2 Feb 2021 15:00:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
        d=hansenpartnership.com; s=20151216; t=1612306835;
        bh=NegTp8fookjQYG6nvXxAhnEsy5s1BaHZMwSCW3Xa9wM=;
        h=Message-ID:Subject:From:To:Date:In-Reply-To:References:From;
        b=kfukBhhirwxq5dM+x0Pc9UubcNRqkBbVSkVHJvV6dpdys0ky5lOacQDjLxg3gEV9p
         hrKblYat6SL3EezMhVRG94uMXbL7mbArKxwSARnTy0C0HJT00ERLnWeZ2i/owDD+Ol
         2p2OQSUqZoh3MNs4YmXQ1BWMyZT1cMVbIC2NvWec=
Message-ID: <957c4efbfa22cb590ea8227718d1bbdcd690410a.camel@HansenPartnership.com>
Subject: Re: [PATCH] tpm: WARN_ONCE() -> pr_warn_once() in tpm_tis_status()
From:   James Bottomley <James.Bottomley@HansenPartnership.com>
To:     Jarkko Sakkinen <jarkko@kernel.org>
Cc:     "Serge E. Hallyn" <serge@hallyn.com>,
        linux-integrity@vger.kernel.org,
        Guenter Roeck <linux@roeck-us.net>, stable@vger.kernel.org,
        Peter Huewe <peterhuewe@gmx.de>,
        Jason Gunthorpe <jgg@ziepe.ca>,
        Stefan Berger <stefanb@linux.ibm.com>,
        Wang Hai <wanghai38@huawei.com>
Date:   Tue, 02 Feb 2021 15:00:34 -0800
In-Reply-To: <YBnR2YLitNJzvNBk@kernel.org>
References: <20210202153317.57749-1-jarkko@kernel.org>
         <20210202172651.GA2821@mail.hallyn.com>
         <1d661a6bdf2d7a9a31b3357ef4170a1309cf2aa4.camel@HansenPartnership.com>
         <YBnR2YLitNJzvNBk@kernel.org>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.34.4 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, 2021-02-03 at 00:27 +0200, Jarkko Sakkinen wrote:
> On Tue, Feb 02, 2021 at 09:58:24AM -0800, James Bottomley wrote:
> > On Tue, 2021-02-02 at 11:26 -0600, Serge E. Hallyn wrote:
[...]
> > > 
> > > Actually in this case I don't understand why _once, especially
> > > based on the comment.  Would ratelimited not be better?  So we
> > > can see if it happens repeatedly?  Even better would be if we
> > > could see when it next gave a valid status after an invalid one.
> > 
> > The reason was that we're trying to catch and kill paths to the
> > status where the locality is incorrect.  If you do some operation
> > that finds an incorrect path the likelihood is you'll exercise it
> > more than once, but all we need to identify it is the call trace
> > from a single access.  The symptom the user space process sees is a
> > TPM timeout, but we still have the in-kernel trace to tell us why.
> 
> I don't agree with this reasoning. This warn could spun off also from
> chip not following TCG spec.

If it doesn't follow this basic part of the spec, the chip is unusable
by us anyway because we need the status to proceed with command
handling.

>  The patch does provide the status code, which is always useful
> information.

In the wrong locality that will be bus not connected, so likely 0xff. 
The most useful thing to know is what path triggered the condition
because the most likely cause is coding error.

James



