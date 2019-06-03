Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1BC933322D
	for <lists+stable@lfdr.de>; Mon,  3 Jun 2019 16:31:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729087AbfFCObw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Jun 2019 10:31:52 -0400
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:60606 "EHLO
        bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728975AbfFCObw (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Jun 2019 10:31:52 -0400
Received: from localhost (localhost [127.0.0.1])
        by bedivere.hansenpartnership.com (Postfix) with ESMTP id A82388EE1D8;
        Mon,  3 Jun 2019 07:31:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=hansenpartnership.com;
        s=20151216; t=1559572311;
        bh=dBf6OsH1dH1yiJZKwGirpHIR1BMjca9GHmos7hCcdg0=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=YGxWww1S7CcKvc1sv2E62wGx8Ey/cpVtHAKv/JuRQR4FcmB7DEFuQ3Fri7Rkfw+Df
         G9K033KMQ28qgVyxK9MlIkX/z1A566W4I+THsAO3pzFLu1rCTehu+q0zF7yMetx1Rk
         h4bceWm/oVJ7OmjWxyvsVPcFyxRSbt973N8QCYlI=
Received: from bedivere.hansenpartnership.com ([127.0.0.1])
        by localhost (bedivere.hansenpartnership.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id 5R8vaiKHL1DO; Mon,  3 Jun 2019 07:31:51 -0700 (PDT)
Received: from jarvis.guest.haifa.ibm.com (unknown [195.110.41.42])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by bedivere.hansenpartnership.com (Postfix) with ESMTPSA id 2191D8EE104;
        Mon,  3 Jun 2019 07:31:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=hansenpartnership.com;
        s=20151216; t=1559572311;
        bh=dBf6OsH1dH1yiJZKwGirpHIR1BMjca9GHmos7hCcdg0=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=YGxWww1S7CcKvc1sv2E62wGx8Ey/cpVtHAKv/JuRQR4FcmB7DEFuQ3Fri7Rkfw+Df
         G9K033KMQ28qgVyxK9MlIkX/z1A566W4I+THsAO3pzFLu1rCTehu+q0zF7yMetx1Rk
         h4bceWm/oVJ7OmjWxyvsVPcFyxRSbt973N8QCYlI=
Message-ID: <1559572305.5052.19.camel@HansenPartnership.com>
Subject: Re: [PATCH v2 2/3] ima: don't ignore INTEGRITY_UNKNOWN EVM status
From:   James Bottomley <James.Bottomley@HansenPartnership.com>
To:     Roberto Sassu <roberto.sassu@huawei.com>,
        Mimi Zohar <zohar@linux.ibm.com>, dmitry.kasatkin@huawei.com,
        mjg59@google.com
Cc:     linux-integrity@vger.kernel.org,
        linux-security-module@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, silviu.vlasceanu@huawei.com,
        stable@vger.kernel.org
Date:   Mon, 03 Jun 2019 17:31:45 +0300
In-Reply-To: <3667fbd4-b6ed-6a76-9ff4-84ec3c2dda12@huawei.com>
References: <20190529133035.28724-1-roberto.sassu@huawei.com>
         <20190529133035.28724-3-roberto.sassu@huawei.com>
         <1559217621.4008.7.camel@linux.ibm.com>
         <e6b31aa9-0319-1805-bdfc-3ddde5884494@huawei.com>
         <1559569401.5052.17.camel@HansenPartnership.com>
         <3667fbd4-b6ed-6a76-9ff4-84ec3c2dda12@huawei.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.26.6 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 2019-06-03 at 16:29 +0200, Roberto Sassu wrote:
> On 6/3/2019 3:43 PM, James Bottomley wrote:
> > On Mon, 2019-06-03 at 11:25 +0200, Roberto Sassu wrote:
> > > On 5/30/2019 2:00 PM, Mimi Zohar wrote:
> > > > On Wed, 2019-05-29 at 15:30 +0200, Roberto Sassu wrote:
> > > > > Currently, ima_appraise_measurement() ignores the EVM status
> > > > > when evm_verifyxattr() returns INTEGRITY_UNKNOWN. If a file
> > > > > has a valid security.ima xattr with type IMA_XATTR_DIGEST or
> > > > > IMA_XATTR_DIGEST_NG, ima_appraise_measurement() returns
> > > > > INTEGRITY_PASS regardless of the EVM status. The problem is
> > > > > that the EVM status is overwritten with the appraisal statu
> > > > 
> > > > Roberto, your framing of this problem is harsh and
> > > > misleading.  IMA and EVM are intentionally independent of each
> > > > other and can be configured independently of each other.  The
> > > > intersection of the two is the call to
> > > > evm_verifyxattr().  INTEGRITY_UNKNOWN is
> > > > returned for a number of reasons - when EVM is not configured,
> > > > the EVM hmac key has not yet been loaded, the protected
> > > > security attribute is unknown, or the file is not in policy.
> > > > 
> > > > This patch does not differentiate between any of the above
> > > > cases, requiring mutable files to always be protected by EVM,
> > > > when specified as an "ima_appraise=" option on the boot command
> > > > line.
> > > > 
> > > > IMA could be extended to require EVM on a per IMA policy rule
> > > > basis. Instead of framing allowing IMA file hashes without EVM
> > > > as a bug that has existed from the very beginning, now that
> > > > IMA/EVM have matured and is being used, you could frame it as
> > > > extending IMA or hardening.
> > > 
> > > I'm seeing it from the perspective of an administrator that
> > > manages an already hardened system, and expects that the system
> > > only grants access to files with a valid signature/HMAC. That
> > > system would not enforce this behavior if EVM keys are removed
> > > and the digest in security.ima is set to the actual file digest.
> > > 
> > > Framing it as a bug rather than an extension would in my opinion
> > > help to convince people about the necessity to switch to the safe
> > > mode, if their system is already hardened.
> > 
> > I have a use case for IMA where I use it to enforce immutability of
> > containers.  In this use case, the cluster admin places hashes on
> > executables as the image is unpacked so that if an executable file
> > is changed, IMA will cause an execution failure.  For this use
> > case, I don't care about the EVM, in fact we don't use it, because
> > the only object is to fail execution if a binary is mutated.
> 
> How would you prevent root in the container from updating
> security.ima?

We don't.  We only guarantee immutability for unprivileged containers,
so root can't be inside.

James

