Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CD8521748DB
	for <lists+stable@lfdr.de>; Sat, 29 Feb 2020 20:22:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727202AbgB2TV4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 29 Feb 2020 14:21:56 -0500
Received: from mout.web.de ([217.72.192.78]:55279 "EHLO mout.web.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727102AbgB2TV4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 29 Feb 2020 14:21:56 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=web.de;
        s=dbaedf251592; t=1583004110;
        bh=4vOX+xF+xSTLGy9c2nd2Kp1RnOhFtxVGsaRmPIJi/0o=;
        h=X-UI-Sender-Class:Subject:To:Cc:References:From:Date:In-Reply-To;
        b=dzbp/1QVeX4ZE75s/GLL7DZtLRHTmFj+U0u3eF7VRqEZfOaU266PedXX5jcVJYIYi
         PyZq6yRvxbfavoZgqukJc2AMW8W8UDUsMZz5aPkYt/R6tdnjRNYG2K2K8h75EiFHVZ
         P51eZzxfK7iIPLl4HY9K7mXP6OY+R28dlq6c9aFM=
X-UI-Sender-Class: c548c8c5-30a9-4db5-a2e7-cb6cb037b8f9
Received: from [192.168.1.10] ([95.157.55.156]) by smtp.web.de (mrweb102
 [213.165.67.124]) with ESMTPSA (Nemesis) id 0MHY1o-1j71DW2xDA-003NBz; Sat, 29
 Feb 2020 20:21:50 +0100
Subject: Re: [FYI PATCH 1/3] KVM: nVMX: Don't emulate instructions in guest
 mode
To:     Jim Mattson <jmattson@google.com>, Oliver Upton <oupton@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        kvm list <kvm@vger.kernel.org>, stable@vger.kernel.org
References: <1582570596-45387-1-git-send-email-pbonzini@redhat.com>
 <1582570596-45387-2-git-send-email-pbonzini@redhat.com>
 <41d80479-7dbc-d912-ff0e-acd48746de0f@web.de>
 <CAOQ_QshE7SMX2cO7H+21Fkdpg53oE2D3xrHPJHR_MCfH4r9QCQ@mail.gmail.com>
 <CALMp9eRETy1RLWHWKtFHqpcpFHbQKtPgJHDD_N+LPzaUPx-Jvg@mail.gmail.com>
From:   Jan Kiszka <jan.kiszka@web.de>
Message-ID: <e8fe4664-d948-f239-4ec9-82d9010b7d26@web.de>
Date:   Sat, 29 Feb 2020 20:21:49 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <CALMp9eRETy1RLWHWKtFHqpcpFHbQKtPgJHDD_N+LPzaUPx-Jvg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:EKz25Ah2+8MOc9guJNdx+0x6R3CUt0e4NA8KwV3MJliBvCABGiI
 0g/hZLKsFuP0fRjjbEqsZajUWwGYCUNJ4bL64XgiV0OzuFbjRpqa20gFm0LXsR5J4Dt2iBF
 dcv4zg6GIAuaAwoXpSqU8VWiG8dw/olg5NG07gNVvlGO4eNpmV4Q1qCfN1ALkruLE/XD7B7
 v+GsIrTrPzqdIZ3mmQxjg==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:/OfomhGOPdk=:Z34tYd4LHWxvt2dpONy5Ak
 aaz4GxNDzUe9LdaErqv3x3pLtvVSzsxM382VkMEx8sOYqUnu5Wz3N3kBrKGxIV6duSKI8d/OD
 xEysCygDxvmDVE0V3VIH/T40l1PZWF2M7I0iC+Hg+u+ZeaawvQ/dmLSrQXktf+I7HyZn+Xdtb
 D6bDzdtIvXGRzRgChQMNziP11xNDclUyWsrODlxJsn/ieGEZsQtv6DlUKnjLuqf62naTUqU/w
 TF9FLglzoqp57P750dQ+s5cIG/dfrDYmkzTyjGb/QHw6KcGc5hYCnWctAIiIzgp9DtYAxZhD1
 W3tFVvLa+kr9x7irk/AZ+PrIU5Ry09vSHUCTuJzzeRLqPf0FzN7DGne38LPqWWpNnie1mKiGy
 YDBpXjCLePc1jlx7m3yCXPQG9ZV3kRUqU5bdEem8wgL9nioNUPCeWcnRRykRWktrnAVfLw+NN
 Fbt0nBY0N1xKE5jZrxfZrNszyZcdsanjQVr/NtwHNW9zp56zBLvo2q58jhG85Az4muJFWAJ+v
 MPIVQSL8hrNAXAGwsh/8GepITITUOVQd/NxeSf2ZIzJLa/RO5uuZpMzsHK9CLMj6yfUjtf7KN
 PPY5UrRP9ST4x/UBWjsKRFWiRjofDtQY2ifzjyP37S9qLfQdyuwvw2xVe6ooUr48KIilHPlEY
 txcwC0ssJLThwP+SHu66oHhHx/kt3kyFpcUG2EOmR9s5N2YTJV8GWoURTJd+t5dqA6TYDomrn
 xr0XkPwdOzB/fvUr9KPSyL/hdkLPp/Uv3ehiCOwSNJ8amJvJmmOqxcvqLvZQGXo0F+zqmXxuq
 wyGZPjXlg89q2pkkxqFThS5k5ecdvusO7QEKSOvP6ZD3lUHbNUVBKk7mN38ZKonG3Kno44+ZE
 AYLbY3br3fk6+4OOsiSDCuoMEnR+pKBRciKbDgtNwBNRsu5KJLMzW7L6gZAJXXga0pMrPMwkz
 wMGRV9W9i8f6/DCLf40th4Y8JAMCXM21swdL9yJrtqMlBjCyepPp1u2wRUjdrgQmeTtZYKYzo
 EMa1O5ssZUEJTB5w/skmmCT7DC4Iwj7L3SgKVZUN80OWXQoczUOCBOEN40Rw9X2qgUIUicYRQ
 n6yNM2n6wawouqpqojA+dcJa6J/Em3/PIXqJD5ektNYsbdAwiN0Oi5/30ZqIVMjp3NzD0bkj+
 KZdkNvsS+lz5GxrN8isJyhAPvSYOF/lz3pA6Vuc8+lCSZlQNl3Ei0L3zC99zZmg3y/YMx0kf4
 VlcXydJX6dv5CGANz
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 29.02.20 20:00, Jim Mattson wrote:
> On Sat, Feb 29, 2020 at 10:33 AM Oliver Upton <oupton@google.com> wrote:
>>
>> Hi Jan,
>>
>> On Sat, Feb 29, 2020 at 10:00 AM Jan Kiszka <jan.kiszka@web.de> wrote:
>>> Is this expected to cause regressions on less common workloads?
>>> Jailhouse as L1 now fails when Linux as L2 tries to boot a CPU: L2-Lin=
ux
>>> gets a triple fault on load_current_idt() in start_secondary(). Only
>>> bisected so far, didn't debug further.
>>
>> I'm guessing that Jailhouse doesn't use 'descriptor table exiting', so
>> when KVM gets the corresponding exit from L2 the emulation burden is
>> on L0. We now refuse the emulation, which kicks a #UD back to L2. I
>> can get a patch out quickly to address this case (like the PIO exiting
>> one that came in this series) but the eventual solution is to map
>> emulator intercept checks into VM-exits + call into the
>> nested_vmx_exit_reflected() plumbing.
>
> If Jailhouse doesn't use descriptor table exiting, why is L0
> intercepting descriptor table instructions? Is this just so that L0
> can partially emulate UMIP on hardware that doesn't support it?
>

That seems to be the case: My host lacks umip, L1 has it. So, KVM is
intercepting descriptor table load instructions to emulate umip.
Jailhouse never activates that interception.

Jan
