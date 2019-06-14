Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 68EDC45A57
	for <lists+stable@lfdr.de>; Fri, 14 Jun 2019 12:26:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727052AbfFNK0I (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 Jun 2019 06:26:08 -0400
Received: from Galois.linutronix.de ([146.0.238.70]:37402 "EHLO
        Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726884AbfFNK0I (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 14 Jun 2019 06:26:08 -0400
Received: from [5.158.153.52] (helo=nanos.tec.linutronix.de)
        by Galois.linutronix.de with esmtpsa (TLS1.2:DHE_RSA_AES_256_CBC_SHA256:256)
        (Exim 4.80)
        (envelope-from <tglx@linutronix.de>)
        id 1hbjOi-0007bd-4m; Fri, 14 Jun 2019 12:25:28 +0200
Date:   Fri, 14 Jun 2019 12:25:27 +0200 (CEST)
From:   Thomas Gleixner <tglx@linutronix.de>
To:     Tim Chen <tim.c.chen@linux.intel.com>
cc:     Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ben Greear <greearb@candelatech.com>, stable@vger.kernel.org,
        Andi Kleen <ak@linux.intel.com>,
        Dave Hansen <dave.hansen@intel.com>,
        Jun Nakajima <jun.nakajima@intel.com>,
        Jiri Kosina <jikos@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Ingo Molnar <mingo@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        David Woodhouse <dwmw@amazon.co.uk>,
        Asit Mallick <asit.k.mallick@intel.com>,
        Arjan van de Ven <arjan@linux.intel.com>,
        Jon Masters <jcm@redhat.com>,
        Waiman Long <longman9394@gmail.com>,
        Borislav Petkov <bp@alien8.de>,
        Mark Gross <mgross@linux.intel.com>,
        LKML <linux-kernel@vger.kernel.org>, x86@kernel.org
Subject: Re: [PATCH v2] Documentation: Add section about CPU vulnerabilities
 for Spectre
In-Reply-To: <914630f02992a96af92b9229f3d083c6284bfb98.1559844311.git.tim.c.chen@linux.intel.com>
Message-ID: <alpine.DEB.2.21.1906141156180.1722@nanos.tec.linutronix.de>
References: <914630f02992a96af92b9229f3d083c6284bfb98.1559844311.git.tim.c.chen@linux.intel.com>
User-Agent: Alpine 2.21 (DEB 202 2017-01-01)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Tim,

On Thu, 6 Jun 2019, Tim Chen wrote:

> Here's a revised version of the spectre documentation.

thanks for the follow up!

> +++ b/Documentation/admin-guide/hw-vuln/spectre.rst
> @@ -0,0 +1,619 @@

Please add a SPDX license identifier

> +Spectre side channels
> +=====================
> +
> +Spectre is a class of side channel attacks that exploit branch prediction
> +and speculative execution on modern CPUs to read memory, possibly
> +bypassing access controls. Speculative execution side channel exploits
> +do not modify memory but attempt to infer privileged data in the memory.
> +
> +This document covers Spectre variant 1 and Spectre variant 2.
> +
> +Affected processors
> +-------------------
> +
> +Speculative execution side channel methods affect a wide range of modern
> +high performance processors, since most modern high speed processors
> +use branch predictions and speculative executions.

  branch prediction and speculative execution

> +
> +The following CPUs are vulnerable:
> +
> +    - Intel Core, Atom, Pentium, and Xeon processors
> +    - AMD Phenom, EPYC, and Zen processors
> +    - IBM POWER and zSeries processors
> +    - Higher end ARM processors
> +    - Apple CPUs
> +    - Higher end MIPS CPUs
> +    - Likely most other high performance CPUs. Contact your CPU vendor for details.

Please use line breaks. They work nicely in lists.

> +
> +Whether a processor is affected or not can be read out from the Spectre
> +vulnerability files in sysfs. See :ref:`spectre_sys_info`.
> +
> +Related CVEs
> +------------
> +
> +The following CVE entries describe Spectre variants:
> +
> +   =============   =======================  =================
> +   CVE-2017-5753   Bounds check bypass      Spectre variant 1
> +   CVE-2017-5715   Branch target injection  Spectre variant 2
> +   =============   =======================  =================
> +
> +Problem
> +-------
> +
> +CPUs use speculative operations to improve performance. That may leave
> +traces of memory accesses or computations in the processor's caches,
> +buffers, and branch predictors. Malicious software may be able to
> +influence the speculative execution paths, and then use the side effects
> +of the speculative execution in the CPUs caches and buffers to infer
> +privileged data touched during the speculative execution.
> +
> +Spectre variant 1 attacks take advantage of speculative execution of
> +conditional branches, while Spectre variant 2 attacks use speculative
> +execution of indirect branches to leak privileged memory. See [1] [5]
> +[7] [10] [11].
> +
> +Spectre variant 1 (Bounds Check Bypass)
> +---------------------------------------
> +
> +The bounds check bypass attack [2] takes advantage of speculative
> +execution that bypass conditional branch instructions used for memory
> +access bounds check (e.g. checking if the index of an array results in
> +memory access within a valid range). This results in memory accesses to
> +invalid memory (say with out-of-bound index) that are done speculatively

s/say//

> +before validation checks resolve. Such speculative memory accesses can
> +leave side effects, creating side channels which leak information to
> +the attacker.
> +
> +There are some extensions of Spectre variant 1 attacks for reading
> +data over the network, see [12]. However such attacks are difficult,
> +low bandwidth, fragile, and are considered low risk.
> +
> +Spectre variant 2 (Branch Target Injection)
> +-------------------------------------------
> +
> +The branch target injection attack takes advantage of speculative
> +execution of indirect branches [3].  The indirect branch predictors
> +inside the processor used to guess the target of indirect branches can
> +be influenced by an attacker, causing gadget code to be speculatively
> +executed, thus exposing sensitive data touched by the victim. The side
> +effects left in the CPU's caches during speculative execution can be
> +measured to infer data values.
> +
> +.. _poison_btb:
> +
> +In Spectre variant 2 attacks, the attacker can steer speculative indirect
> +branches in the victim to gadget code by poisoning the branch target
> +buffer of a CPU used for predicting indirect branch addresses. Such
> +poisoning could be done by indirect branching into existing code, with the
> +address offset of the indirect branch under the attacker's control. Since
> +the branch prediction hardware does not fully disambiguate branch address
> +and uses the offset for prediction, this could cause privileged code's
> +indirect branch to jump to a gadget code with the same offset.
> +
> +The most useful gadgets take an attacker-controlled input parameter (such
> +as a register value) so that the memory read can be controlled. Gadgets
> +without input parameters might be possible, but the attacker would have
> +very little control over what memory can be read, reducing the risk of
> +the attack revealing useful data.
> +
> +One other variant 2 attack vector is for the attacker to poison the
> +return stack buffer (RSB) [13] to cause speculative RET execution to go
> +to an gadget.  An attacker's imbalanced CALL instructions might "poison"
> +entries in the return stack buffer which are later consumed by a victim's
> +RET instruction.  This attack can be mitigated by flushing the return
> +stack buffer on context switch, or VM exit.

This should mention that SMT sibling threads can be affected because L1 and
BTB can be shared resources.

> +Attack scenarios
> +----------------
> +
> +The following list of attack scenarios have been anticipated, but may
> +not cover all possible attack vectors.
> +
> +1. A user process attacking the kernel
> +^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
> +
> +   The attacker passes a parameter to the kernel via a register or via a
> +   known address in memory during a syscall. Such parameter may be used
> +   later by the kernel as an index to an array or to derive a pointer
> +   for Spectre variant 1 attack.  The index or pointer is invalid, but

... for a Spectre ...


> +2. A user process attacking another user process
> +^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
> +
> +   A malicious user process can try to attack another user process,
> +   either via a context switch on the same hardware thread, or from the
> +   sibling hyperthread sharing a physical processor core on simultaneous
> +   multi-threading (SMT) system.
> +
> +   Spectre variant 1 attacks generally require passing parameters between
> +   the processes, which needs a data passing relationship, such as remote
> +   procedure calls (RPC).  Those parameters are used in gadget code to
> +   derive invalid data pointers accessing privileged memory.

priviledged memory in the attacked process.

> +   Spectre variant 2 attacks can be launched by a rogue process by
> +   :ref:`poisoning <poison_btb>` the branch target buffer.  This can
> +   influence the indirect branch targets for a victim process that either
> +   runs later on the same hardware thread, or running concurrently on
> +   a sibling hardware thread running on the same physical core.

s/thread running on/thread sharing/

> +   On x86, a user process can protect itself against Spectre variant 2
> +   attacks by using prctl syscall to disable indirect branch speculation

s/using prctl syscall/using the prctl() syscall/

> +   for itself.  An administrator can also cordon off an unsafe process
> +   from polluting the branch target buffer by disabling the process's
> +   indirect branch speculation. This comes with a performance cost from
> +   disabling indirect branch speculation and clearing the branch target
> +   buffer.  On SMT CPU, for a process that has indirect branch speculation

s/On SMT CPU/When SMT is enabled

> +   disabled, Single Threaded Indirect Branch Predictors (STIBP) [4]
> +   is turned on to prevent the sibling thread from controlling branch

s/is/are/	Predictors are clearly plural

> +   target buffer.  In addition, Indirect Branch Prediction Barrier (IBPB)

In addition, the Indirect ..

> +   is issued to clear the branch target buffer when context switching
> +   to and from such process.
> +
> +   On x86, the return stack buffer is stuffed on context switch.
> +   This prevents the branch target buffer from being used for branch
> +   prediction when the return stack buffer underflow while switching to

underflows

> +   a deeper call stack. Any poisoned entries in the return stack buffer
> +   left by the previous process will also be cleared.
> +
> +   User programs should use address space randomization to make attacks
> +   more difficult (Set /proc/sys/kernel/randomize_va_space = 1 or 2).
> +
> +3. A virtualized guest attacking the host
> +^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
> +
> +   The attack mechanism is similar to how user processes attack the
> +   kernel.  The kernel is entered via hyper calls or other virtualization

Please use the 'hyper-call' notation consistently.

> +   exit paths.
> +
> +   For Spectre variant 1 attack, rogue guests can pass parameters (e.g. in

either: For a Spectre variant 1 attack,
or:     For Spectre variant 1 attacks,

> +   registers) via hyper-calls to derive invalid pointers to speculate
> +   into privileged memory after entering the kernel.  For places where
> +   such kernel code are identified, nospec accessor macros are used to

s/are/has been identified/

> +   stop speculative memory access.
> +
> +   For Spectre variant 2 attack, rogue guests can :ref:`poison

See above.

> +   <poison_btb>` the branch target buffer or return stack buffer, causing
> +   the kernel to jump to gadget code in the speculative execution paths.
> +
> +   To mitigate variant 2, the host kernel can use return trampoline

trampolines

> +   for indirect branches to bypass poisoned branch target buffer, and

to bypass the

> +   flushes return stack buffer on VM exit.  This prevents rogue guest

s/and flushes return/and flushing the return/

> +   from affecting indirect branching in host kernel.
> +
> +   To protect host processes from rogue guests, host processes can have
> +   indirect branch speculation disabled via prctl.  The branch target

prctl()

> +   buffer is cleared before context switching to such processes.
> +
> +4. A virtualized guest attacking other guest
> +^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
> +
> +   A rogue guest may attack another guest to get data accessible by the
> +   other guest.
> +
> +   Spectre variant 1 attack is possible if parameters can be passed
> +   between guests.  This may be done via mechanisms such as shared memory
> +   or message passing.  Such parameters could be used to derive data
> +   pointers to privileged data in guest.  The privileged data could be
> +   accessed by gadget code in the victim's speculation paths.
> +
> +   Spectre variant 2 attack can be launched from a rogue guest by
> +   :ref:`poisoning <poison_btb>` the branch target buffer or return stack
> +   buffer. Such poisoned entries could be used to influence speculation
> +   execution paths in the victim guest. Linux kernel mitigates such
> +   attacks by flushing the return stack buffer on VM exit and also clears
> +   the branch target buffer before switching to a new guest.

This needs to explain that this is not preventing SMT sibling attacks.

> +Turning on mitigation for Spectre variant 1 and Spectre variant 2
> +-----------------------------------------------------------------
> +
> +1. Kernel mitigation
> +^^^^^^^^^^^^^^^^^^^^
> +
> +   For Spectre variant 1, vulnerable kernel codes (as determined by code

For the Spectre ..

s/codes/code/

> +   audit or scanning tools) are annotated on a case by case basis to use
> +   nospec accessor macros for bounds clipping [2] to avoid any usable
> +   disclosure gadgets. However, it may not cover all attack vectors for
> +   Spectre variant 1.
> +
> +   For Spectre variant 2 mitigation, the compiler turns indirect calls or

> +   jumps in the kernel into an equivalent return trampolines (retpoline)

s/an//

> +   [3] [9] to go to the target addresses.  Speculative execution paths
> +   under retpolines are trapped in an infinite loop to prevent any
> +   speculative execution jumping to a gadget.
> +
> +   To turn on retpoline mitigation on a vulnerable CPU, the kernel
> +   needs to be compiled with a gcc compiler that supports the
> +   -mindirect-branch=thunk-extern -mindirect-branch-register options.
> +   If the kernel is compiled with a clangs compiler, the compiler needs

s/clangs/Clang/

> +2. User program mitigation
> +^^^^^^^^^^^^^^^^^^^^^^^^^^
> +
> +   User programs can mitigate Spectre variant 1 using LFENCE or "bounds
> +   clipping". For more details see [2].
> +
> +   For Spectre variant 2 mitigation, individual user programs
> +   can be compiled with return trampolines for indirect branches.
> +   This protects them from consuming poisoned entries in Branch Target

in the Branch...

> +   Buffer left by malicious software.  Alternatively, the programs
> +   can disable their indirect branch speculation via prctl (See

prctl()

> +   :ref:`Documentation/userspace-api/spec_ctrl.rst <set_spec_ctrl>`)
> +   On x86, this will turn on STIBP to guard against attacks from the
> +   sibling thread when the user program is running, and use IBPB to
> +   flush the branch target buffer when switching to/from the program.

> +3. VM mitigation
> +^^^^^^^^^^^^^^^^
> +
> +   Within the kernel, Spectre variant 1 attacks from rogue guests
> +   are mitigated on a case by case basis in VM exit paths. Vulnerable
> +   codes use nospec accessor macros for "bounds clipping", to avoid any

code uses

> +   usable disclosure gadgets.  However, this may not cover all variant
> +   1 attack vectors.
> +
> +   For Spectre variant 2 attacks from rogue guests to the kernel, the
> +   Linux kernel uses retpoline to prevent consumption of poisoned entries

uses retpoline or Enhanced IBRS

> +   in branch target buffer left by rogue guests.  It also flushes the
> +   return stack buffer on every VM exit to prevent return stack buffer

prevent a return ...

> +   underflow so poisoned branch target buffer could be used, or attacker
> +   guests leaving poisoned entries in the return stack buffer.
> +
> +   To mitigate guest-to-guest attacks, the branch target buffer is
> +   sanitized by flushing before switching to a new guest on a CPU.
> +
> +   These mitigations are turned on by default on vulnerable CPUs.
> +
> +   The kernel also allows guests to use any microcode based mitigation
> +   they chose to use (such as IBPB or STIBP on x86).
> +
> +.. _mitigation_control_command_line:

...

Aside of the few nitpicks this is a very well done document!

Thanks,

	tglx
