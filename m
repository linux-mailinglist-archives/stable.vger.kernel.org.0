Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 94C1066B6BE
	for <lists+stable@lfdr.de>; Mon, 16 Jan 2023 05:47:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231830AbjAPErw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 15 Jan 2023 23:47:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60746 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232011AbjAPErR (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 15 Jan 2023 23:47:17 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D9A8D91
        for <stable@vger.kernel.org>; Sun, 15 Jan 2023 20:46:41 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 576F7B80C97
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 04:46:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 819FBC433D2;
        Mon, 16 Jan 2023 04:46:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1673844399;
        bh=w8+zbvyrsI/jcpbexsQd5LvgAMvNAol7/ZbzBF8zXEQ=;
        h=Date:From:To:Cc:Subject:From;
        b=OeHR32P+x91bkoredU/1YCJideMKpKtrqN/UkHc5dN6tSLQDLGJOVzohZGeUscIEM
         extuI2X6cttdmczZ+1ctxe8f7Rm7lpYUiV5Ls7BH5AK0f1BqmQYj5dSxl5iejQaKDk
         qmXgUUlAQVgMjHvBzYxx76wjerZNEQ9yBRWZhbMUzqhOEOifMOT28fbnFWs3645GOD
         A5or/I30DqwDM4w72e700Ez8HEUtt6yhwJI7Qf6Kg3YtitKua1VDTsBxNQBkoAKBUf
         kLEe0WRg7AnAXVHM5HQpLa7EadhqDTgLiNkWB0ow2mcUSjvHZNc1WgzM8gWZX0C8A9
         7ED8m9bWpVXwQ==
Date:   Sun, 15 Jan 2023 21:46:36 -0700
From:   Nathan Chancellor <nathan@kernel.org>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>
Cc:     stable@vger.kernel.org, llvm@lists.linux.dev,
        Nick Desaulniers <ndesaulniers@google.com>,
        YingChi Long <me@inclyc.cn>, Borislav Petkov <bp@alien8.de>,
        Steven Rostedt <rostedt@goodmis.org>
Subject: offsetof() backports for clang-16+
Message-ID: <Y8TWrJpb6Vn6E4+v@dev-arch.thelio-3990X>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="+U7wrB+7DuTiAPUk"
Content-Disposition: inline
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--+U7wrB+7DuTiAPUk
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Greg and Sasha,

Clang 16 (current main, next major release) errors when offsetof() has a
type defintion in it, in response to language in newer C standards
stating it is undefined behavior.

https://github.com/llvm/llvm-project/commit/e327b52766ed497e4779f4e652b9ad237dfda8e6
https://reviews.llvm.org/D133574

While this might be eventually demoted to just a warning, the kernel has
already cleaned up places that had this construct, so we can apply them
to the stable trees and avoid the issue altogether.

Please find attached mbox files for all supported stable trees, which
fix up the relevant instances for each tree using the upstream commits:

55228db2697c ("x86/fpu: Use _Alignof to avoid undefined behavior in TYPE_ALIGN")
09794a5a6c34 ("tracing: Use alignof__(struct {type b;}) instead of offsetof()")

The fpu commit uses _Alignof, which as far as I can tell was only
supported in GCC 4.7.0+. This is not a problem for mainline due to
requiring GCC 5.1.0+ but it could be relevant for old trees like 4.14,
which have an older minimum supported version. I hope people are not
using ancient compilers like that but I suppose if they are using 4.14,
they might just be stuck with old software...

If there are any issues or comments, please let me know.
Nathan

--+U7wrB+7DuTiAPUk
Content-Type: application/mbox
Content-Disposition: attachment; filename="4.14.mbox"
Content-Transfer-Encoding: quoted-printable

=46rom 980618fd33732ebfbe97daf10e8ebc13400aee3e Mon Sep 17 00:00:00 2001=0A=
=46rom: YingChi Long <me@inclyc.cn>=0ADate: Fri, 18 Nov 2022 08:55:35 +0800=
=0ASubject: [PATCH 4.14] x86/fpu: Use _Alignof to avoid undefined behavior =
in=0A TYPE_ALIGN=0A=0Acommit 55228db2697c09abddcb9487c3d9fa5854a932cd upstr=
eam.=0A=0AWG14 N2350 specifies that it is an undefined behavior to have typ=
e=0Adefinitions within offsetof", see=0A=0A  https://www.open-std.org/jtc1/=
sc22/wg14/www/docs/n2350.htm=0A=0AThis specification is also part of C23.=
=0A=0ATherefore, replace the TYPE_ALIGN macro with the _Alignof builtin to=
=0Aavoid undefined behavior. (_Alignof itself is C11 and the kernel is=0Abu=
ilt with -gnu11).=0A=0AISO C11 _Alignof is subtly different from the GNU C =
extension=0A__alignof__. Latter is the preferred alignment and _Alignof the=
=0Aminimal alignment. For long long on x86 these are 8 and 4=0Arespectively=
=2E=0A=0AThe macro TYPE_ALIGN's behavior matches _Alignof rather than=0A__a=
lignof__.=0A=0A  [ bp: Massage commit message. ]=0A=0ASigned-off-by: YingCh=
i Long <me@inclyc.cn>=0ASigned-off-by: Borislav Petkov <bp@suse.de>=0ARevie=
wed-by: Nick Desaulniers <ndesaulniers@google.com>=0ALink: https://lore.ker=
nel.org/r/20220925153151.2467884-1-me@inclyc.cn=0ASigned-off-by: Nathan Cha=
ncellor <nathan@kernel.org>=0A---=0A arch/x86/kernel/fpu/init.c | 7 ++-----=
=0A 1 file changed, 2 insertions(+), 5 deletions(-)=0A=0Adiff --git a/arch/=
x86/kernel/fpu/init.c b/arch/x86/kernel/fpu/init.c=0Aindex 9692ccc583bb..a3=
a570df6be1 100644=0A--- a/arch/x86/kernel/fpu/init.c=0A+++ b/arch/x86/kerne=
l/fpu/init.c=0A@@ -138,9 +138,6 @@ static void __init fpu__init_system_gene=
ric(void)=0A unsigned int fpu_kernel_xstate_size;=0A EXPORT_SYMBOL_GPL(fpu_=
kernel_xstate_size);=0A =0A-/* Get alignment of the TYPE. */=0A-#define TYP=
E_ALIGN(TYPE) offsetof(struct { char x; TYPE test; }, test)=0A-=0A /*=0A  *=
 Enforce that 'MEMBER' is the last field of 'TYPE'.=0A  *=0A@@ -148,8 +145,=
8 @@ EXPORT_SYMBOL_GPL(fpu_kernel_xstate_size);=0A  * because that's how C =
aligns structs.=0A  */=0A #define CHECK_MEMBER_AT_END_OF(TYPE, MEMBER) \=0A=
-	BUILD_BUG_ON(sizeof(TYPE) !=3D ALIGN(offsetofend(TYPE, MEMBER), \=0A-				=
	   TYPE_ALIGN(TYPE)))=0A+	BUILD_BUG_ON(sizeof(TYPE) !=3D         \=0A+		  =
   ALIGN(offsetofend(TYPE, MEMBER), _Alignof(TYPE)))=0A =0A /*=0A  * We app=
end the 'struct fpu' to the task_struct:=0A=0Abase-commit: c4215ee4771bb935=
727df2db097fd28f8d644b5c=0A-- =0A2.39.0=0A=0A
--+U7wrB+7DuTiAPUk
Content-Type: application/mbox
Content-Disposition: attachment; filename="4.19.mbox"
Content-Transfer-Encoding: quoted-printable

=46rom 56f2f15b0ea75dfe5ab5f304ab7c4972162e0ea1 Mon Sep 17 00:00:00 2001=0A=
=46rom: YingChi Long <me@inclyc.cn>=0ADate: Fri, 18 Nov 2022 08:55:35 +0800=
=0ASubject: [PATCH 4.19] x86/fpu: Use _Alignof to avoid undefined behavior =
in=0A TYPE_ALIGN=0A=0Acommit 55228db2697c09abddcb9487c3d9fa5854a932cd upstr=
eam.=0A=0AWG14 N2350 specifies that it is an undefined behavior to have typ=
e=0Adefinitions within offsetof", see=0A=0A  https://www.open-std.org/jtc1/=
sc22/wg14/www/docs/n2350.htm=0A=0AThis specification is also part of C23.=
=0A=0ATherefore, replace the TYPE_ALIGN macro with the _Alignof builtin to=
=0Aavoid undefined behavior. (_Alignof itself is C11 and the kernel is=0Abu=
ilt with -gnu11).=0A=0AISO C11 _Alignof is subtly different from the GNU C =
extension=0A__alignof__. Latter is the preferred alignment and _Alignof the=
=0Aminimal alignment. For long long on x86 these are 8 and 4=0Arespectively=
=2E=0A=0AThe macro TYPE_ALIGN's behavior matches _Alignof rather than=0A__a=
lignof__.=0A=0A  [ bp: Massage commit message. ]=0A=0ASigned-off-by: YingCh=
i Long <me@inclyc.cn>=0ASigned-off-by: Borislav Petkov <bp@suse.de>=0ARevie=
wed-by: Nick Desaulniers <ndesaulniers@google.com>=0ALink: https://lore.ker=
nel.org/r/20220925153151.2467884-1-me@inclyc.cn=0ASigned-off-by: Nathan Cha=
ncellor <nathan@kernel.org>=0A---=0A arch/x86/kernel/fpu/init.c | 7 ++-----=
=0A 1 file changed, 2 insertions(+), 5 deletions(-)=0A=0Adiff --git a/arch/=
x86/kernel/fpu/init.c b/arch/x86/kernel/fpu/init.c=0Aindex 9692ccc583bb..a3=
a570df6be1 100644=0A--- a/arch/x86/kernel/fpu/init.c=0A+++ b/arch/x86/kerne=
l/fpu/init.c=0A@@ -138,9 +138,6 @@ static void __init fpu__init_system_gene=
ric(void)=0A unsigned int fpu_kernel_xstate_size;=0A EXPORT_SYMBOL_GPL(fpu_=
kernel_xstate_size);=0A =0A-/* Get alignment of the TYPE. */=0A-#define TYP=
E_ALIGN(TYPE) offsetof(struct { char x; TYPE test; }, test)=0A-=0A /*=0A  *=
 Enforce that 'MEMBER' is the last field of 'TYPE'.=0A  *=0A@@ -148,8 +145,=
8 @@ EXPORT_SYMBOL_GPL(fpu_kernel_xstate_size);=0A  * because that's how C =
aligns structs.=0A  */=0A #define CHECK_MEMBER_AT_END_OF(TYPE, MEMBER) \=0A=
-	BUILD_BUG_ON(sizeof(TYPE) !=3D ALIGN(offsetofend(TYPE, MEMBER), \=0A-				=
	   TYPE_ALIGN(TYPE)))=0A+	BUILD_BUG_ON(sizeof(TYPE) !=3D         \=0A+		  =
   ALIGN(offsetofend(TYPE, MEMBER), _Alignof(TYPE)))=0A =0A /*=0A  * We app=
end the 'struct fpu' to the task_struct:=0A=0Abase-commit: c652c812211c7a42=
7d16be1d3f904eb02eb4265f=0A-- =0A2.39.0=0A=0A
--+U7wrB+7DuTiAPUk
Content-Type: application/mbox
Content-Disposition: attachment; filename="5.4.mbox"
Content-Transfer-Encoding: quoted-printable

=46rom b405368325499077828cedf8c6a49bfcca748940 Mon Sep 17 00:00:00 2001=0A=
=46rom: YingChi Long <me@inclyc.cn>=0ADate: Fri, 18 Nov 2022 08:55:35 +0800=
=0ASubject: [PATCH 5.4] x86/fpu: Use _Alignof to avoid undefined behavior i=
n=0A TYPE_ALIGN=0A=0Acommit 55228db2697c09abddcb9487c3d9fa5854a932cd upstre=
am.=0A=0AWG14 N2350 specifies that it is an undefined behavior to have type=
=0Adefinitions within offsetof", see=0A=0A  https://www.open-std.org/jtc1/s=
c22/wg14/www/docs/n2350.htm=0A=0AThis specification is also part of C23.=0A=
=0ATherefore, replace the TYPE_ALIGN macro with the _Alignof builtin to=0Aa=
void undefined behavior. (_Alignof itself is C11 and the kernel is=0Abuilt =
with -gnu11).=0A=0AISO C11 _Alignof is subtly different from the GNU C exte=
nsion=0A__alignof__. Latter is the preferred alignment and _Alignof the=0Am=
inimal alignment. For long long on x86 these are 8 and 4=0Arespectively.=0A=
=0AThe macro TYPE_ALIGN's behavior matches _Alignof rather than=0A__alignof=
__.=0A=0A  [ bp: Massage commit message. ]=0A=0ASigned-off-by: YingChi Long=
 <me@inclyc.cn>=0ASigned-off-by: Borislav Petkov <bp@suse.de>=0AReviewed-by=
: Nick Desaulniers <ndesaulniers@google.com>=0ALink: https://lore.kernel.or=
g/r/20220925153151.2467884-1-me@inclyc.cn=0ASigned-off-by: Nathan Chancello=
r <nathan@kernel.org>=0A---=0A arch/x86/kernel/fpu/init.c | 7 ++-----=0A 1 =
file changed, 2 insertions(+), 5 deletions(-)=0A=0Adiff --git a/arch/x86/ke=
rnel/fpu/init.c b/arch/x86/kernel/fpu/init.c=0Aindex b271da0fa219..17d092eb=
1934 100644=0A--- a/arch/x86/kernel/fpu/init.c=0A+++ b/arch/x86/kernel/fpu/=
init.c=0A@@ -139,9 +139,6 @@ static void __init fpu__init_system_generic(vo=
id)=0A unsigned int fpu_kernel_xstate_size;=0A EXPORT_SYMBOL_GPL(fpu_kernel=
_xstate_size);=0A =0A-/* Get alignment of the TYPE. */=0A-#define TYPE_ALIG=
N(TYPE) offsetof(struct { char x; TYPE test; }, test)=0A-=0A /*=0A  * Enfor=
ce that 'MEMBER' is the last field of 'TYPE'.=0A  *=0A@@ -149,8 +146,8 @@ E=
XPORT_SYMBOL_GPL(fpu_kernel_xstate_size);=0A  * because that's how C aligns=
 structs.=0A  */=0A #define CHECK_MEMBER_AT_END_OF(TYPE, MEMBER) \=0A-	BUIL=
D_BUG_ON(sizeof(TYPE) !=3D ALIGN(offsetofend(TYPE, MEMBER), \=0A-					   TY=
PE_ALIGN(TYPE)))=0A+	BUILD_BUG_ON(sizeof(TYPE) !=3D         \=0A+		     ALI=
GN(offsetofend(TYPE, MEMBER), _Alignof(TYPE)))=0A =0A /*=0A  * We append th=
e 'struct fpu' to the task_struct:=0A=0Abase-commit: 851c2b5fb7936d54e1147f=
76f88e2675f9f82b52=0A-- =0A2.39.0=0A=0A
--+U7wrB+7DuTiAPUk
Content-Type: application/mbox
Content-Disposition: attachment; filename="5.10.mbox"
Content-Transfer-Encoding: quoted-printable

=46rom 3cd07cd561e7444d259d7aa79297dd7a4717ad6b Mon Sep 17 00:00:00 2001=0A=
=46rom: YingChi Long <me@inclyc.cn>=0ADate: Fri, 18 Nov 2022 08:55:35 +0800=
=0ASubject: [PATCH 5.10 1/2] x86/fpu: Use _Alignof to avoid undefined behav=
ior in=0A TYPE_ALIGN=0A=0Acommit 55228db2697c09abddcb9487c3d9fa5854a932cd u=
pstream.=0A=0AWG14 N2350 specifies that it is an undefined behavior to have=
 type=0Adefinitions within offsetof", see=0A=0A  https://www.open-std.org/j=
tc1/sc22/wg14/www/docs/n2350.htm=0A=0AThis specification is also part of C2=
3.=0A=0ATherefore, replace the TYPE_ALIGN macro with the _Alignof builtin t=
o=0Aavoid undefined behavior. (_Alignof itself is C11 and the kernel is=0Ab=
uilt with -gnu11).=0A=0AISO C11 _Alignof is subtly different from the GNU C=
 extension=0A__alignof__. Latter is the preferred alignment and _Alignof th=
e=0Aminimal alignment. For long long on x86 these are 8 and 4=0Arespectivel=
y.=0A=0AThe macro TYPE_ALIGN's behavior matches _Alignof rather than=0A__al=
ignof__.=0A=0A  [ bp: Massage commit message. ]=0A=0ASigned-off-by: YingChi=
 Long <me@inclyc.cn>=0ASigned-off-by: Borislav Petkov <bp@suse.de>=0AReview=
ed-by: Nick Desaulniers <ndesaulniers@google.com>=0ALink: https://lore.kern=
el.org/r/20220925153151.2467884-1-me@inclyc.cn=0ASigned-off-by: Nathan Chan=
cellor <nathan@kernel.org>=0A---=0A arch/x86/kernel/fpu/init.c | 7 ++-----=
=0A 1 file changed, 2 insertions(+), 5 deletions(-)=0A=0Adiff --git a/arch/=
x86/kernel/fpu/init.c b/arch/x86/kernel/fpu/init.c=0Aindex 701f196d7c68..3c=
0a621b9792 100644=0A--- a/arch/x86/kernel/fpu/init.c=0A+++ b/arch/x86/kerne=
l/fpu/init.c=0A@@ -138,9 +138,6 @@ static void __init fpu__init_system_gene=
ric(void)=0A unsigned int fpu_kernel_xstate_size;=0A EXPORT_SYMBOL_GPL(fpu_=
kernel_xstate_size);=0A =0A-/* Get alignment of the TYPE. */=0A-#define TYP=
E_ALIGN(TYPE) offsetof(struct { char x; TYPE test; }, test)=0A-=0A /*=0A  *=
 Enforce that 'MEMBER' is the last field of 'TYPE'.=0A  *=0A@@ -148,8 +145,=
8 @@ EXPORT_SYMBOL_GPL(fpu_kernel_xstate_size);=0A  * because that's how C =
aligns structs.=0A  */=0A #define CHECK_MEMBER_AT_END_OF(TYPE, MEMBER) \=0A=
-	BUILD_BUG_ON(sizeof(TYPE) !=3D ALIGN(offsetofend(TYPE, MEMBER), \=0A-				=
	   TYPE_ALIGN(TYPE)))=0A+	BUILD_BUG_ON(sizeof(TYPE) !=3D         \=0A+		  =
   ALIGN(offsetofend(TYPE, MEMBER), _Alignof(TYPE)))=0A =0A /*=0A  * We app=
end the 'struct fpu' to the task_struct:=0A=0Abase-commit: 19ff2d645f7a9626=
146b6b3ba698488d60aa04de=0A-- =0A2.39.0=0A=0A=0AFrom cbaf7397ab38a82c6a2a1c=
79c0f8c5ada44954f4 Mon Sep 17 00:00:00 2001=0AFrom: "Steven Rostedt (Google=
)" <rostedt@goodmis.org>=0ADate: Tue, 2 Aug 2022 15:44:12 -0400=0ASubject: =
[PATCH 5.10 2/2] tracing: Use alignof__(struct {type b;}) instead of=0A off=
setof()=0A=0Acommit 09794a5a6c348f629b35fc1687071a1622ef4265 upstream.=0A=
=0ASimplify:=0A=0A  #define ALIGN_STRUCTFIELD(type) ((int)(offsetof(struct =
{char a; type b;}, b)))=0A=0Awith=0A=0A  #define  ALIGN_STRUCTFIELD(type) _=
_alignof__(struct {type b;})=0A=0AWhich works just the same.=0A=0ALink: htt=
ps://lore.kernel.org/all/a7d202457150472588df0bd3b7334b3f@AcuMS.aculab.com/=
=0ALink: https://lkml.kernel.org/r/20220802154412.513c50e3@gandalf.local.ho=
me=0A=0ASuggested-by: David Laight <David.Laight@ACULAB.COM>=0ASigned-off-b=
y: Steven Rostedt (Google) <rostedt@goodmis.org>=0ASigned-off-by: Nathan Ch=
ancellor <nathan@kernel.org>=0A---=0A include/trace/trace_events.h | 2 +-=
=0A 1 file changed, 1 insertion(+), 1 deletion(-)=0A=0Adiff --git a/include=
/trace/trace_events.h b/include/trace/trace_events.h=0Aindex d74c076e9e2b..=
717d388ecbd6 100644=0A--- a/include/trace/trace_events.h=0A+++ b/include/tr=
ace/trace_events.h=0A@@ -400,7 +400,7 @@ static struct trace_event_function=
s trace_event_type_funcs_##call =3D {	\=0A =0A #include TRACE_INCLUDE(TRACE=
_INCLUDE_FILE)=0A =0A-#define ALIGN_STRUCTFIELD(type) ((int)(offsetof(struc=
t {char a; type b;}, b)))=0A+#define ALIGN_STRUCTFIELD(type) ((int)(__align=
of__(struct {type b;})))=0A =0A #undef __field_ext=0A #define __field_ext(_=
type, _item, _filter_type) {			\=0A-- =0A2.39.0=0A=0A
--+U7wrB+7DuTiAPUk
Content-Type: application/mbox
Content-Disposition: attachment; filename="5.15.mbox"
Content-Transfer-Encoding: quoted-printable

=46rom b3e3778c5939f77318ab62d404846bb0526f8079 Mon Sep 17 00:00:00 2001=0A=
=46rom: YingChi Long <me@inclyc.cn>=0ADate: Fri, 18 Nov 2022 08:55:35 +0800=
=0ASubject: [PATCH 5.15 1/2] x86/fpu: Use _Alignof to avoid undefined behav=
ior in=0A TYPE_ALIGN=0A=0Acommit 55228db2697c09abddcb9487c3d9fa5854a932cd u=
pstream.=0A=0AWG14 N2350 specifies that it is an undefined behavior to have=
 type=0Adefinitions within offsetof", see=0A=0A  https://www.open-std.org/j=
tc1/sc22/wg14/www/docs/n2350.htm=0A=0AThis specification is also part of C2=
3.=0A=0ATherefore, replace the TYPE_ALIGN macro with the _Alignof builtin t=
o=0Aavoid undefined behavior. (_Alignof itself is C11 and the kernel is=0Ab=
uilt with -gnu11).=0A=0AISO C11 _Alignof is subtly different from the GNU C=
 extension=0A__alignof__. Latter is the preferred alignment and _Alignof th=
e=0Aminimal alignment. For long long on x86 these are 8 and 4=0Arespectivel=
y.=0A=0AThe macro TYPE_ALIGN's behavior matches _Alignof rather than=0A__al=
ignof__.=0A=0A  [ bp: Massage commit message. ]=0A=0ASigned-off-by: YingChi=
 Long <me@inclyc.cn>=0ASigned-off-by: Borislav Petkov <bp@suse.de>=0AReview=
ed-by: Nick Desaulniers <ndesaulniers@google.com>=0ALink: https://lore.kern=
el.org/r/20220925153151.2467884-1-me@inclyc.cn=0ASigned-off-by: Nathan Chan=
cellor <nathan@kernel.org>=0A---=0A arch/x86/kernel/fpu/init.c | 7 ++-----=
=0A 1 file changed, 2 insertions(+), 5 deletions(-)=0A=0Adiff --git a/arch/=
x86/kernel/fpu/init.c b/arch/x86/kernel/fpu/init.c=0Aindex 64e29927cc32..c9=
49424a11c1 100644=0A--- a/arch/x86/kernel/fpu/init.c=0A+++ b/arch/x86/kerne=
l/fpu/init.c=0A@@ -138,9 +138,6 @@ static void __init fpu__init_system_gene=
ric(void)=0A unsigned int fpu_kernel_xstate_size __ro_after_init;=0A EXPORT=
_SYMBOL_GPL(fpu_kernel_xstate_size);=0A =0A-/* Get alignment of the TYPE. *=
/=0A-#define TYPE_ALIGN(TYPE) offsetof(struct { char x; TYPE test; }, test)=
=0A-=0A /*=0A  * Enforce that 'MEMBER' is the last field of 'TYPE'.=0A  *=
=0A@@ -148,8 +145,8 @@ EXPORT_SYMBOL_GPL(fpu_kernel_xstate_size);=0A  * bec=
ause that's how C aligns structs.=0A  */=0A #define CHECK_MEMBER_AT_END_OF(=
TYPE, MEMBER) \=0A-	BUILD_BUG_ON(sizeof(TYPE) !=3D ALIGN(offsetofend(TYPE, =
MEMBER), \=0A-					   TYPE_ALIGN(TYPE)))=0A+	BUILD_BUG_ON(sizeof(TYPE) !=3D=
         \=0A+		     ALIGN(offsetofend(TYPE, MEMBER), _Alignof(TYPE)))=0A =
=0A /*=0A  * We append the 'struct fpu' to the task_struct:=0A=0Abase-commi=
t: 90bb4f8f399f63c479c188f3771a38e9a42791d9=0A-- =0A2.39.0=0A=0A=0AFrom 340=
27bb69f5a3e69cf9082f38f486745a4fc5643 Mon Sep 17 00:00:00 2001=0AFrom: "Ste=
ven Rostedt (Google)" <rostedt@goodmis.org>=0ADate: Tue, 2 Aug 2022 15:44:1=
2 -0400=0ASubject: [PATCH 5.15 2/2] tracing: Use alignof__(struct {type b;}=
) instead of=0A offsetof()=0A=0Acommit 09794a5a6c348f629b35fc1687071a1622ef=
4265 upstream.=0A=0ASimplify:=0A=0A  #define ALIGN_STRUCTFIELD(type) ((int)=
(offsetof(struct {char a; type b;}, b)))=0A=0Awith=0A=0A  #define  ALIGN_ST=
RUCTFIELD(type) __alignof__(struct {type b;})=0A=0AWhich works just the sam=
e.=0A=0ALink: https://lore.kernel.org/all/a7d202457150472588df0bd3b7334b3f@=
AcuMS.aculab.com/=0ALink: https://lkml.kernel.org/r/20220802154412.513c50e3=
@gandalf.local.home=0A=0ASuggested-by: David Laight <David.Laight@ACULAB.CO=
M>=0ASigned-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>=0ASigned-=
off-by: Nathan Chancellor <nathan@kernel.org>=0A---=0A include/trace/trace_=
events.h | 2 +-=0A 1 file changed, 1 insertion(+), 1 deletion(-)=0A=0Adiff =
--git a/include/trace/trace_events.h b/include/trace/trace_events.h=0Aindex=
 a77b690709cc..7f0b91dfb532 100644=0A--- a/include/trace/trace_events.h=0A+=
++ b/include/trace/trace_events.h=0A@@ -479,7 +479,7 @@ static struct trace=
_event_functions trace_event_type_funcs_##call =3D {	\=0A =0A #include TRAC=
E_INCLUDE(TRACE_INCLUDE_FILE)=0A =0A-#define ALIGN_STRUCTFIELD(type) ((int)=
(offsetof(struct {char a; type b;}, b)))=0A+#define ALIGN_STRUCTFIELD(type)=
 ((int)(__alignof__(struct {type b;})))=0A =0A #undef __field_ext=0A #defin=
e __field_ext(_type, _item, _filter_type) {			\=0A-- =0A2.39.0=0A=0A
--+U7wrB+7DuTiAPUk
Content-Type: application/mbox
Content-Disposition: attachment; filename="6.1.mbox"
Content-Transfer-Encoding: quoted-printable

=46rom 839cb44916a5f7c2f504ae631831492208d94d41 Mon Sep 17 00:00:00 2001=0A=
=46rom: YingChi Long <me@inclyc.cn>=0ADate: Fri, 18 Nov 2022 08:55:35 +0800=
=0ASubject: [PATCH 6.1] x86/fpu: Use _Alignof to avoid undefined behavior i=
n=0A TYPE_ALIGN=0A=0Acommit 55228db2697c09abddcb9487c3d9fa5854a932cd upstre=
am.=0A=0AWG14 N2350 specifies that it is an undefined behavior to have type=
=0Adefinitions within offsetof", see=0A=0A  https://www.open-std.org/jtc1/s=
c22/wg14/www/docs/n2350.htm=0A=0AThis specification is also part of C23.=0A=
=0ATherefore, replace the TYPE_ALIGN macro with the _Alignof builtin to=0Aa=
void undefined behavior. (_Alignof itself is C11 and the kernel is=0Abuilt =
with -gnu11).=0A=0AISO C11 _Alignof is subtly different from the GNU C exte=
nsion=0A__alignof__. Latter is the preferred alignment and _Alignof the=0Am=
inimal alignment. For long long on x86 these are 8 and 4=0Arespectively.=0A=
=0AThe macro TYPE_ALIGN's behavior matches _Alignof rather than=0A__alignof=
__.=0A=0A  [ bp: Massage commit message. ]=0A=0ASigned-off-by: YingChi Long=
 <me@inclyc.cn>=0ASigned-off-by: Borislav Petkov <bp@suse.de>=0AReviewed-by=
: Nick Desaulniers <ndesaulniers@google.com>=0ALink: https://lore.kernel.or=
g/r/20220925153151.2467884-1-me@inclyc.cn=0ASigned-off-by: Nathan Chancello=
r <nathan@kernel.org>=0A---=0A arch/x86/kernel/fpu/init.c | 7 ++-----=0A 1 =
file changed, 2 insertions(+), 5 deletions(-)=0A=0Adiff --git a/arch/x86/ke=
rnel/fpu/init.c b/arch/x86/kernel/fpu/init.c=0Aindex 8946f89761cc..851eb13e=
dc01 100644=0A--- a/arch/x86/kernel/fpu/init.c=0A+++ b/arch/x86/kernel/fpu/=
init.c=0A@@ -133,9 +133,6 @@ static void __init fpu__init_system_generic(vo=
id)=0A 	fpu__init_system_mxcsr();=0A }=0A =0A-/* Get alignment of the TYPE.=
 */=0A-#define TYPE_ALIGN(TYPE) offsetof(struct { char x; TYPE test; }, tes=
t)=0A-=0A /*=0A  * Enforce that 'MEMBER' is the last field of 'TYPE'.=0A  *=
=0A@@ -143,8 +140,8 @@ static void __init fpu__init_system_generic(void)=0A=
  * because that's how C aligns structs.=0A  */=0A #define CHECK_MEMBER_AT_=
END_OF(TYPE, MEMBER) \=0A-	BUILD_BUG_ON(sizeof(TYPE) !=3D ALIGN(offsetofend=
(TYPE, MEMBER), \=0A-					   TYPE_ALIGN(TYPE)))=0A+	BUILD_BUG_ON(sizeof(TYP=
E) !=3D         \=0A+		     ALIGN(offsetofend(TYPE, MEMBER), _Alignof(TYPE)=
))=0A =0A /*=0A  * We append the 'struct fpu' to the task_struct:=0A=0Abase=
-commit: 38f3ee12661fdc2805e06942e4e3d604e03cd9cf=0A-- =0A2.39.0=0A=0A
--+U7wrB+7DuTiAPUk--
