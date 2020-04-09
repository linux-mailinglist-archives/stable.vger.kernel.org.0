Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 17DD01A358C
	for <lists+stable@lfdr.de>; Thu,  9 Apr 2020 16:14:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726983AbgDIONu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 Apr 2020 10:13:50 -0400
Received: from esa4.hc3370-68.iphmx.com ([216.71.155.144]:39704 "EHLO
        esa4.hc3370-68.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726977AbgDIONu (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 9 Apr 2020 10:13:50 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=citrix.com; s=securemail; t=1586441629;
  h=subject:to:cc:references:from:message-id:date:
   mime-version:in-reply-to:content-transfer-encoding;
  bh=yrdagwIUFtKwt9MOyKCVl5M6aNY/cfIdCXlLoDli1mo=;
  b=RmW0ycWECRy2O+5SUYHNrhL4uNdjFn65RoMiOZ3DjJAg0EgtIiXhyveJ
   NIKJkEa46Axn+/0qoQBSeOgZgnFB/jWSDyMfslGq1qdLDfHXvHiWoQR/N
   WkeE1tTIB381HV22INysfWtTXzN4TaytnuUfqdCBlXmcazt9vEh5tBGCU
   s=;
Authentication-Results: esa4.hc3370-68.iphmx.com; dkim=none (message not signed) header.i=none; spf=None smtp.pra=andrew.cooper3@citrix.com; spf=Pass smtp.mailfrom=Andrew.Cooper3@citrix.com; spf=None smtp.helo=postmaster@mail.citrix.com
Received-SPF: None (esa4.hc3370-68.iphmx.com: no sender
  authenticity information available from domain of
  andrew.cooper3@citrix.com) identity=pra;
  client-ip=162.221.158.21; receiver=esa4.hc3370-68.iphmx.com;
  envelope-from="Andrew.Cooper3@citrix.com";
  x-sender="andrew.cooper3@citrix.com";
  x-conformance=sidf_compatible
Received-SPF: Pass (esa4.hc3370-68.iphmx.com: domain of
  Andrew.Cooper3@citrix.com designates 162.221.158.21 as
  permitted sender) identity=mailfrom;
  client-ip=162.221.158.21; receiver=esa4.hc3370-68.iphmx.com;
  envelope-from="Andrew.Cooper3@citrix.com";
  x-sender="Andrew.Cooper3@citrix.com";
  x-conformance=sidf_compatible; x-record-type="v=spf1";
  x-record-text="v=spf1 ip4:209.167.231.154 ip4:178.63.86.133
  ip4:195.66.111.40/30 ip4:85.115.9.32/28 ip4:199.102.83.4
  ip4:192.28.146.160 ip4:192.28.146.107 ip4:216.52.6.88
  ip4:216.52.6.188 ip4:162.221.158.21 ip4:162.221.156.83
  ip4:168.245.78.127 ~all"
Received-SPF: None (esa4.hc3370-68.iphmx.com: no sender
  authenticity information available from domain of
  postmaster@mail.citrix.com) identity=helo;
  client-ip=162.221.158.21; receiver=esa4.hc3370-68.iphmx.com;
  envelope-from="Andrew.Cooper3@citrix.com";
  x-sender="postmaster@mail.citrix.com";
  x-conformance=sidf_compatible
IronPort-SDR: zMk+TKhFbvmlTvoCJdMSK9a1ddjz6WkQv7BWesBz+ogcJU8kOEJKQncyCsihklOwhLbAH9bieq
 ovx75BttbXMGRC2n5IP1+jzMc8rPHC+15aAyeMUUkyRwD/b57GZTH+wszLrtZxgm2PQymMTvUf
 r1tL6PHFTbL/fTQvDQyVbUu9dJe5o+bSJqST5Q1Wx1gv8RB4xP5wa3GM9jIooKST7vc4ARc7pC
 jnaUgAs9TAetgBX8EMdc5lphvZLvvA9lcVd9Fgyd2zEJ1wu7ewwYQ8pGs52v/Z9aM1g8DrATom
 c9k=
X-SBRS: 2.7
X-MesageID: 16107785
X-Ironport-Server: esa4.hc3370-68.iphmx.com
X-Remote-IP: 162.221.158.21
X-Policy: $RELAYED
X-IronPort-AV: E=Sophos;i="5.72,363,1580792400"; 
   d="scan'208";a="16107785"
Subject: Re: [PATCH v2] x86/kvm: Disable KVM_ASYNC_PF_SEND_ALWAYS
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Andy Lutomirski <luto@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>
CC:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Vivek Goyal <vgoyal@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        LKML <linux-kernel@vger.kernel.org>, X86 ML <x86@kernel.org>,
        kvm list <kvm@vger.kernel.org>, stable <stable@vger.kernel.org>
References: <20200407172140.GB64635@redhat.com>
 <772A564B-3268-49F4-9AEA-CDA648F6131F@amacapital.net>
 <87eeszjbe6.fsf@nanos.tec.linutronix.de>
 <ce81c95f-8674-4012-f307-8f32d0e386c2@redhat.com>
 <874ktukhku.fsf@nanos.tec.linutronix.de>
 <274f3d14-08ac-e5cc-0b23-e6e0274796c8@redhat.com>
 <20200408153413.GA11322@linux.intel.com>
 <ce28e893-2ed0-ea6f-6c36-b08bb0d814f2@redhat.com>
 <87d08hc0vz.fsf@nanos.tec.linutronix.de>
 <CALCETrWG2Y4SPmVkugqgjZcMfpQiq=YgsYBmWBm1hj_qx3JNVQ@mail.gmail.com>
 <04aca08a-cfce-b4db-559a-23aee0a0b7aa@redhat.com>
From:   Andrew Cooper <andrew.cooper3@citrix.com>
Message-ID: <0b632fb1-b662-89bf-2b95-6888bd64b3a9@citrix.com>
Date:   Thu, 9 Apr 2020 15:13:41 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <04aca08a-cfce-b4db-559a-23aee0a0b7aa@redhat.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Content-Language: en-GB
X-ClientProxiedBy: AMSPEX02CAS02.citrite.net (10.69.22.113) To
 AMSPEX02CL02.citrite.net (10.69.22.126)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 09/04/2020 13:47, Paolo Bonzini wrote:
> On 09/04/20 06:50, Andy Lutomirski wrote:
>> The small
>> (or maybe small) one is that any fancy protocol where the guest
>> returns from an exception by doing, logically:
>>
>> Hey I'm done;  /* MOV somewhere, hypercall, MOV to CR4, whatever */
>> IRET;
>>
>> is fundamentally racy.  After we say we're done and before IRET, we
>> can be recursively reentered.  Hi, NMI!
> That's possible in theory.  In practice there would be only two levels
> of nesting, one for the original page being loaded and one for the tail
> of the #VE handler.  The nested #VE would see IF=0, resolve the EPT
> violation synchronously and both handlers would finish.  For the tail
> page to be swapped out again, leading to more nesting, the host's LRU
> must be seriously messed up.
>
> With IST it would be much messier, and I haven't quite understood why
> you believe the #VE handler should have an IST.

Any interrupt/exception which can possibly occur between a SYSCALL and
re-establishing a kernel stack (several instructions), must be IST to
avoid taking said exception on a user stack and being a trivial
privilege escalation.

In terms of using #VE in its architecturally-expected way, this can
occur in general before the kernel stack is established, so must be IST
for safety.

Therefore, it doesn't really matter if KVM's paravirt use of #VE does
respect the interrupt flag.  It is not sensible to build a paravirt
interface using #VE who's safety depends on never turning on
hardware-induced #VE's.

~Andrew
