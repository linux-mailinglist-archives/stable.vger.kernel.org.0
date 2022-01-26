Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 68DFD49D463
	for <lists+stable@lfdr.de>; Wed, 26 Jan 2022 22:20:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231185AbiAZVUC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 26 Jan 2022 16:20:02 -0500
Received: from mail-eus2azon11020025.outbound.protection.outlook.com ([52.101.56.25]:36834
        "EHLO na01-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229569AbiAZVUC (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 26 Jan 2022 16:20:02 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XuS4SzWqb4Md5XnwzokHKWK3QsUFHxMYYEMERwe+hbvX2njiDIgWMsgrwylWbY10xZqBjAHrcY8DucWM8yPv08N2G9CH46LlpbB0Rh7Ap3FhGdCjlkG2FfvWOrW9OEKFGYyxQIhW9vJ2wq27WJgGAKr9TEjv4E/uhcEatSYKX0INEQ1YBQkm2+Y371yGtuUWER/gTlHpkwxJ2TPJnE70tNCYsSTNfZBdlZEz5v2AIwtk9ESJWMpbC8YKf1bO8FhqU0TM5DSI2jhPKOPJIp5+Lk6M+PKbP1kI/nkx15Lq6FTcS04q1d7ULJX6IyOP34jsEaFVMO7A1nmmZvsR2CcuEg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4X4KtK+MYk8kIdSfQzuhtMdXNzJHMWWZmSEVnpjJ7mE=;
 b=nR87II1QJ6r7j4V8jpsD/XhPAHh8ICBL/rPw1GklQnjD4z0swfY7XfIOBYAdElqMPxCbX+8GNleaXWQsZja+tdCjj6OsannJ5StDzps6kH7TMuAUYyvGpilWWsQNCRKaDORTIW/+7MGmMKYSFTJjAfy/ndEtAJfe35vzcgDlmLJ5JJWjIw2EktH7y6KFHgmMOa+3aRXRPxSYbd41P+JpKMSGbP0zwmwEORCOkOfFGZoqMYd6/Dl+HDyDYyX5tqVdsliHqkX8RRXC+PcFOMfi/LayFCRUFmftuBv55Ugmaw755FRXCRQmiCEDbaOadl6BV/k0dPDxsu+WFqeYCtLI6A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4X4KtK+MYk8kIdSfQzuhtMdXNzJHMWWZmSEVnpjJ7mE=;
 b=C+CFbeC+okhvnw1rpQRAJ2oqxmfmmEZy3dCUGb6bKQ0uy34fcO8Q/42Eq1JRPToOAmpIwZh9JSu3S4iSFUmVo0XSTuHd5J0Tw5tPP5Q680FcPUgoGkFxQTeYt50CRAX5Q+tCqLxwGBxJ9v3QYwE2pdEBWEPsl3VcL+cSDnrpTPY=
Received: from SJ0PR21MB1311.namprd21.prod.outlook.com (2603:10b6:a03:3fa::17)
 by PH0PR21MB2047.namprd21.prod.outlook.com (2603:10b6:510:ab::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4951.5; Wed, 26 Jan
 2022 21:19:58 +0000
Received: from SJ0PR21MB1311.namprd21.prod.outlook.com
 ([fe80::89a7:a51b:31bc:347f]) by SJ0PR21MB1311.namprd21.prod.outlook.com
 ([fe80::89a7:a51b:31bc:347f%6]) with mapi id 15.20.4951.003; Wed, 26 Jan 2022
 21:19:58 +0000
From:   Bill Messmer <wmessmer@microsoft.com>
To:     Jann Horn <jannh@google.com>,
        Andrew Morton <akpm@linux-foundation.org>
CC:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Eric W . Biederman" <ebiederm@xmission.com>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Randy Dunlap <rdunlap@infradead.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: RE: [EXTERNAL] [PATCH] coredump: Also dump first pages of
 non-executable ELF libraries
Thread-Topic: [EXTERNAL] [PATCH] coredump: Also dump first pages of
 non-executable ELF libraries
Thread-Index: AQHYEmCGZdqQqhvRCECocD6ykp0hLqx1zIug
Date:   Wed, 26 Jan 2022 21:19:58 +0000
Message-ID: <SJ0PR21MB13116C182E5900BF40AC2327C4209@SJ0PR21MB1311.namprd21.prod.outlook.com>
References: <20220126025739.2014888-1-jannh@google.com>
In-Reply-To: <20220126025739.2014888-1-jannh@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=6fcac323-92e4-4bb8-b673-64556a7034d3;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ContentBits=0;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=true;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Method=Standard;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=Internal;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2022-01-26T21:06:55Z;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microsoft.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: a670d3df-779c-4d0d-fdde-08d9e1119b24
x-ms-traffictypediagnostic: PH0PR21MB2047:EE_
x-ms-exchange-atpmessageproperties: SA|SL
x-microsoft-antispam-prvs: <PH0PR21MB20471853144AA05C77A6C6E9C4209@PH0PR21MB2047.namprd21.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: X0c9oL5NBnp/yfo+OlRnZ1bn94ke/1D6Su2mWkDsmHqv3BQa/GKMUXbzXAnEzy84YjEB0Rf2DKg0qRcAzAInNbsARgFGclrPtKyshfl7GEsX/AL+urX3rMnOgckL3Wq8FKJmygnRP0fmvBTM5SbyXaRfz3jLWZeXsJ1lDM/cljUaXzKIi5bkfV77AhAHKFTidKN9nACpKILeASbiCwrJey3OML0SBNyaJXJooTRfYzfbqYNMT3PTOqWJHJtN/sy0bmmpiZc8BQTDaPYA5snGKFqC21BYn/AResc6qC+WEmFXD3p7LA7+sMFxmuD1bE0M96vyG6o/tWMZjcfbo3XB5sOuMgfE3Cz3NTFkS1CYiimLnWH1jdY+aOubYazBkWaAPd8bXCr1UBvIi9rA112NwhNQPM0+8udwqUdAzvnNI6ub0N1tppgxJxD2bXmnX/a3VkzhIAkxJYRU+CVoYjNXLsVcRZ+YvQL4Z//xn12t8r51fGs9dgXkyDcdCmiwu6z14pxQuWKwl5G3PWIX3keiTeooobkX3IywfjoQatBFdpVw47z1HFzeKD8RR0fUHXOY8MomM8FRcQ/uZzapZda+T6AVxQeCPXBm8ob+HM+1/BxplEjnOCgtKKHPOD9QlES7PFoolj3D8lBAo6GfxLtq0S3sYueu6UvwUgu9a1XLEyjxn//kg2EyyPIMf9yWbqYlk3dRMX7bduzIvS2s4e2SpNolvaibuQdXHcH7sA5CghK5ITRWQdBTFtWL3zKllEldD8Ho4Mte9oglt89z3n5hgrVv2gmJtIS1iDjVpp/mJZg=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR21MB1311.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(186003)(38070700005)(122000001)(33656002)(508600001)(10290500003)(5660300002)(966005)(82950400001)(71200400001)(52536014)(110136005)(2906002)(316002)(82960400001)(76116006)(38100700002)(86362001)(8990500004)(4326008)(8676002)(55016003)(83380400001)(8936002)(54906003)(66446008)(7696005)(9686003)(66476007)(66946007)(53546011)(64756008)(6506007)(66556008)(10090945008)(20210929001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?ro2YzfIRMsO79dAslH2KLp2YGZepmOGzQJL96PlbSPxc6sojLLJ/XQRANwj0?=
 =?us-ascii?Q?DdJ66Kmv9WumHFpCeOZfnIS1Pkmr7EysnSgh9fda+aE8ZujHADLZHGoYNZUS?=
 =?us-ascii?Q?EDMGezicWSYWU3fDhNU1VmZJuPyxbtiV195ITtZio72FtbTEN3/KjKucsIcx?=
 =?us-ascii?Q?1/ZyUjNsgI4oPHBsg0BWgwISkc3g1DCOTlX9Qn9tJT/aqVn30oTw07OYkQ0c?=
 =?us-ascii?Q?b7gNj4VqhGoZO1XSzCBNsAUhU1sWNOUhdB2i/KIc4bm6iQqENYSra5V9u69d?=
 =?us-ascii?Q?q+udqJ8pnOXfgqnZtfQrg+wkCXk+xdPCnK9zI8Xx15gnuAC7MFvpIPYq+HKU?=
 =?us-ascii?Q?+RE7lqwxHsgyF5j+XTWY+7sz9tqU+nBagfuU1Pfx2UYVZZHoV4p0C7mzwrwX?=
 =?us-ascii?Q?BDVenqAuZD/vtCghoip1/nM6efJnBLqmJR521OXm03CQzO0yutJGy0+N0kNV?=
 =?us-ascii?Q?ACp4+kgsVKRZnZYIyaYKCkGUehHRZa4e6GR7VsmIrECqqPNjZZ4RzoqcchZT?=
 =?us-ascii?Q?anMyadNSrJVaFubm2pz97OFvfbq9Ep0PzK6l3YlCm8qYB8Nw7DOmOPbxhTrk?=
 =?us-ascii?Q?0jpUua/fIPi+rQoIipzSySc03NnXHhNaOkdqwtMkc0IqVjGyP8WqVAR6AfK/?=
 =?us-ascii?Q?1rCbh6PHdJ6s8yn/GdaYqhLRxKzf3JbG+MEUhXo5gaFxamtCMTaQRk6RV0en?=
 =?us-ascii?Q?ttp+J+ruSV6aTmJmxbbagpeFKNC0hbkuUg1XZFj0Zz5jd/sUBDEim66Agei/?=
 =?us-ascii?Q?o7m5e8CXn+hWaWYiUKgOJZYSLQOGWQIS/qqY6LBGlomqyp+q1fQQa9h8CjEG?=
 =?us-ascii?Q?ZNwaBcl6WnF2N4DuM5P4p34rpEQDqAGwog4wzjNiy6xaY16Fn/fjuIJWwt98?=
 =?us-ascii?Q?N9Rwj7HIH+LWTrLn2BO7de6OvzbqXG0tpjX5qjWVtI/fb4dj28ubXS7x7/h9?=
 =?us-ascii?Q?3Eb+6PcagvrhXPl8Mq1ijx3ZiNHfk8C7Ur+wQGA//INX64aXGvR9nR33UJOU?=
 =?us-ascii?Q?+qX0yfwO5rm9WvSKkrVQxyGz0JfsA8XEJd9c1mtp8i7o51oCOfWUTxTythc1?=
 =?us-ascii?Q?73eG8LRZ+rVm80hgs+c2fndZsehZfkn1iTP7BgkPHmRZtRAZu3utCTHg91CD?=
 =?us-ascii?Q?sMS5F8f5KuTlyIh18XjXrVJfaPXtDsNMfhP84to7QGNdpRs6KeUy/Ozh6Uis?=
 =?us-ascii?Q?Nxy+te7aUpw2AcOObL6OJFps+cFN3k26YCLUuY/lh9u6jsucGkCO2lO4v5s6?=
 =?us-ascii?Q?d/9euGodeCQiL/0MT38fLL2VtrY9uhSXozQECxzfRJgrhbTGg+uurN9Y378o?=
 =?us-ascii?Q?jimP9ta7YAfWMeSwhdbLba2vYQl3Wdrj7yBi/A7go/4qvlvetkezA/CQfRre?=
 =?us-ascii?Q?jWV2ppT2MOP1Kv3EsyPowVVeBO9v+lcVwv3cP/MvZpWbJv+9wFlA3hCsHxdb?=
 =?us-ascii?Q?LAYFb1dchbhPn60NqE7nFQpwxTFW8E7LEXUaBYgpi1O2LAjnLwKhZCA/GyTl?=
 =?us-ascii?Q?6zGZCNVMMWt/k3iTwq4ooRhNbFh0Ojk+PYoe4Phrx0wfLV79C6HIlGeq0mTZ?=
 =?us-ascii?Q?0tc3P5Efv+pE/KKlAEXIyQhVHsqGUYHXtUVLiZojk/H9R0DLDXbCcFdRLW/5?=
 =?us-ascii?Q?4FU4o1tPw6aBurcMbf39IPn9p2wTMoF5ImwdFDVkuDEe/uwFjptQwyggHksa?=
 =?us-ascii?Q?rfhgIg=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR21MB1311.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a670d3df-779c-4d0d-fdde-08d9e1119b24
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 Jan 2022 21:19:58.1622
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Q4J44kRWaEoSxe2sZTyP83XGWcPQjAfDCesXCsELSTk5vdB4agNMqe6E9Wa5a9fVYL8+XlxKoSX1doLv2q7zvg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR21MB2047
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Jann,

Apologies on the delay...  I think it's probably been 20+ years since I've =
built and installed a Linux kernel.  In any case, I cloned the current kern=
el git tree, applied your patch, rebuilt the kernel, and installed it in an=
 Ubuntu 21.10 VM.  After forcing a few process core dumps, it does indeed l=
ook like the problem is fixed.  Just to triple check, I took one of those c=
ore dumps over to the Windows side and opened it with a recent windbg.  It =
finds the build-ids of all the relevant images & SO's just fine:

	0:000> dx @$curprocess.Modules.Select(mod =3D> mod.Contents.BuildID)
	@$curprocess.Modules.Select(mod =3D> mod.Contents.BuildID)               =
=20
	    [0x0]            : Unable to read target memory at '0x7f5766631000' in=
 method 'readMemoryValues' [at ImageInfo (line 1275 col 5)]
	    [0x1]            : EF650611451904165E9CAF6080ECBAAD50B84D3F
	    [0x2]            : 674ACF7BFECD6B8F382FE8D0D95F229087761289
	    [0x3]            : C087D7951738C9EA3DFC7D15A7B31A7D7F862AE1
	    [0x4]            : B8037B6260865346802321DD2256B8AD1D857E63
	    [0x5]            : DB6AFCCC2EC0090045BBE5DDD68722A1434235E5
	    [0x6]            : 3B4B1D0BA98C1B4081A6C5748A593D42C163F125
	    [0x7]            : 4501188BC2E25791E446F7C110F8BC9282C98CD4
	    [0x8]            : AE398331C90E9C84AE01A640DF017803BB775F63
	    [0x9]            : 4E8C3A67A9606B9B33EDF9A24ED999E3C885E5BB
	    [0xa]            : 6511403115C9BC3DF0DCD7167D8766B7FCC2AEE1
	    [0xb]            : 14ACB10BBDAEFC6A64890C96417426CA820C0FAA
	    [0xc]            : 2792043473EB7D1661942BC13DB9272918D2A790

And it is able to match the images/debug information to what I have for my =
Ubuntu VM as well.

Thank you for the fix!

Sincerely,

Bill Messmer
wmessmer@microsoft.com

-----Original Message-----
From: Jann Horn <jannh@google.com>=20
Sent: Tuesday, January 25, 2022 6:58 PM
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org; Bill Messmer <wmessmer@microsoft.com>; Er=
ic W . Biederman <ebiederm@xmission.com>; Al Viro <viro@zeniv.linux.org.uk>=
; Randy Dunlap <rdunlap@infradead.org>; Jann Horn <jannh@google.com>; stabl=
e@vger.kernel.org
Subject: [EXTERNAL] [PATCH] coredump: Also dump first pages of non-executab=
le ELF libraries

[You don't often get email from jannh@google.com. Learn why this is importa=
nt at http://aka.ms/LearnAboutSenderIdentification.]

When I rewrote the VMA dumping logic for coredumps, I changed it to recogni=
ze ELF library mappings based on the file being executable instead of the m=
apping having an ELF header. But turns out, distros ship many ELF libraries=
 as non-executable, so the heuristic goes wrong...

Restore the old behavior where FILTER(ELF_HEADERS) dumps the first page of =
any offset-0 readable mapping that starts with the ELF magic.

This fix is technically layer-breaking a bit, because it checks for somethi=
ng ELF-specific in fs/coredump.c; but since we probably want to share this =
between standard ELF and FDPIC ELF anyway, I guess it's fine?
And this also keeps the change small for backporting.

Cc: stable@vger.kernel.org
Fixes: 429a22e776a2 ("coredump: rework elf/elf_fdpic vma_dump_size() into c=
ommon helper")
Reported-by: Bill Messmer <wmessmer@microsoft.com>
Signed-off-by: Jann Horn <jannh@google.com>
---

@Bill: If you happen to have a kernel tree lying around, you could give thi=
s a try and report back whether this solves your issues?
But if not, it's also fine, I've tested myself that with this patch applied=
, the first 0x1000 bytes of non-executable libraries are dumped into the co=
redump according to "readelf".

 fs/coredump.c | 39 ++++++++++++++++++++++++++++++++++-----
 1 file changed, 34 insertions(+), 5 deletions(-)

diff --git a/fs/coredump.c b/fs/coredump.c index 1c060c0a2d72..b73817712dd2=
 100644
--- a/fs/coredump.c
+++ b/fs/coredump.c
@@ -42,6 +42,7 @@
 #include <linux/path.h>
 #include <linux/timekeeping.h>
 #include <linux/sysctl.h>
+#include <linux/elf.h>

 #include <linux/uaccess.h>
 #include <asm/mmu_context.h>
@@ -980,6 +981,8 @@ static bool always_dump_vma(struct vm_area_struct *vma)
        return false;
 }

+#define DUMP_SIZE_MAYBE_ELFHDR_PLACEHOLDER 1
+
 /*
  * Decide how much of @vma's contents should be included in a core dump.
  */
@@ -1039,9 +1042,20 @@ static unsigned long vma_dump_size(struct vm_area_st=
ruct *vma,
         * dump the first page to aid in determining what was mapped here.
         */
        if (FILTER(ELF_HEADERS) &&
-           vma->vm_pgoff =3D=3D 0 && (vma->vm_flags & VM_READ) &&
-           (READ_ONCE(file_inode(vma->vm_file)->i_mode) & 0111) !=3D 0)
-               return PAGE_SIZE;
+           vma->vm_pgoff =3D=3D 0 && (vma->vm_flags & VM_READ)) {
+               if ((READ_ONCE(file_inode(vma->vm_file)->i_mode) & 0111) !=
=3D 0)
+                       return PAGE_SIZE;
+
+               /*
+                * ELF libraries aren't always executable.
+                * We'll want to check whether the mapping starts with the =
ELF
+                * magic, but not now - we're holding the mmap lock,
+                * so copy_from_user() doesn't work here.
+                * Use a placeholder instead, and fix it up later in
+                * dump_vma_snapshot().
+                */
+               return DUMP_SIZE_MAYBE_ELFHDR_PLACEHOLDER;
+       }

 #undef FILTER

@@ -1116,8 +1130,6 @@ int dump_vma_snapshot(struct coredump_params *cprm, i=
nt *vma_count,
                m->end =3D vma->vm_end;
                m->flags =3D vma->vm_flags;
                m->dump_size =3D vma_dump_size(vma, cprm->mm_flags);
-
-               vma_data_size +=3D m->dump_size;
        }

        mmap_write_unlock(mm);
@@ -1127,6 +1139,23 @@ int dump_vma_snapshot(struct coredump_params *cprm, =
int *vma_count,
                return -EFAULT;
        }

+       for (i =3D 0; i < *vma_count; i++) {
+               struct core_vma_metadata *m =3D (*vma_meta) + i;
+
+               if (m->dump_size =3D=3D DUMP_SIZE_MAYBE_ELFHDR_PLACEHOLDER)=
 {
+                       char elfmag[SELFMAG];
+
+                       if (copy_from_user(elfmag, (void __user *)m->start,=
 SELFMAG) ||
+                                       memcmp(elfmag, ELFMAG, SELFMAG) !=
=3D 0) {
+                               m->dump_size =3D 0;
+                       } else {
+                               m->dump_size =3D PAGE_SIZE;
+                       }
+               }
+
+               vma_data_size +=3D m->dump_size;
+       }
+
        *vma_data_size_ptr =3D vma_data_size;
        return 0;
 }

base-commit: 0280e3c58f92b2fe0e8fbbdf8d386449168de4a8
--
2.35.0.rc0.227.g00780c9af4-goog

