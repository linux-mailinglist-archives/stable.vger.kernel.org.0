Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3404048E91F
	for <lists+stable@lfdr.de>; Fri, 14 Jan 2022 12:27:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230082AbiANL01 convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Fri, 14 Jan 2022 06:26:27 -0500
Received: from mail-eopbgr90073.outbound.protection.outlook.com ([40.107.9.73]:13526
        "EHLO FRA01-MR2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229879AbiANL01 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 14 Jan 2022 06:26:27 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fm0aoXzzKDp7UgIurK4AxPY3mdZ4eGWUS+qKe/lj3vv53WQElRbWrLSpt2NQdYkR0tE4F7CKiBI2E4HHicpSIpPYaWVBa0QNpBgBL4KunCX9dTJyjyIkgFfVodtUd3/REiVPAjWpIyJWicYOtpQtnAu+7OGD38ZK5jKpi4SQa0DeDNaeFliC75s8DBuUSC8HkCu/Ryp4Qo3mJgdyOS5u8k98VhvkSBwesnMh3LVU+YWkXJLz4AeQQdzM+OQdwe8vTgL+lYlcT8IN4S+ebCXJOe3XamdVnrZpkhl7SRZSqTrWAtVXYIesLX6/wUBjUuou/9OcCOK3ILzSVcUhB/yPTw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=C2C/NwTtDtQgl+rlJWJ8fsLfuseAK1izzP74BneaeBs=;
 b=NpOBfKJ9l/dAy4ad92NvuXBgn+830w9x05yf1lUYibJyNs7fGdYk9AxjClzQbXdimtOovjAnTH4YcBURzoRUw70wy6uQXiLNd3+iOWUPHNp48yLgWX6IWzPNxRciaPLKqPxi4DQxHQshxrt99OLbOWwHN3leuGP6gp7Ma2d/j//4e+uWAP1T/7ucPpuaXeuaRYe9sjOXC9dgZQhnFkD6vnNuUNpGr8rQwcWWIjub4ZgD5MUa2sQGs0I/BE+DJ5ICQxSvVh+D7V54g5cf5EiO+khNPAtt3eOgesNeBPIHJe2O2IfGNtm7uAPHPc3/tvtQsSd+vToxZRiatFdrq8bCXg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=csgroup.eu; dmarc=pass action=none header.from=csgroup.eu;
 dkim=pass header.d=csgroup.eu; arc=none
Received: from MRZP264MB2988.FRAP264.PROD.OUTLOOK.COM (2603:10a6:501:31::15)
 by MR1P264MB1843.FRAP264.PROD.OUTLOOK.COM (2603:10a6:501:5::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4888.9; Fri, 14 Jan
 2022 11:26:25 +0000
Received: from MRZP264MB2988.FRAP264.PROD.OUTLOOK.COM
 ([fe80::9d4f:1090:9b36:3fc5]) by MRZP264MB2988.FRAP264.PROD.OUTLOOK.COM
 ([fe80::9d4f:1090:9b36:3fc5%5]) with mapi id 15.20.4888.012; Fri, 14 Jan 2022
 11:26:25 +0000
From:   Christophe Leroy <christophe.leroy@csgroup.eu>
To:     Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        Michael Ellerman <mpe@ellerman.id.au>
CC:     Christophe Leroy <christophe.leroy@csgroup.eu>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
        "Dmitry V . Levin" <ldv@altlinux.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: [PATCH v2] powerpc/audit: Fix syscall_get_arch()
Thread-Topic: [PATCH v2] powerpc/audit: Fix syscall_get_arch()
Thread-Index: AQHYCTmQ5OozDNzIuUGIHMnWiQNl8A==
Date:   Fri, 14 Jan 2022 11:26:25 +0000
Message-ID: <c55cddb8f65713bf5859ed675d75a50cb37d5995.1642159570.git.christophe.leroy@csgroup.eu>
Accept-Language: fr-FR, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=csgroup.eu;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 366ce395-8949-46f2-8c4d-08d9d750b310
x-ms-traffictypediagnostic: MR1P264MB1843:EE_
x-microsoft-antispam-prvs: <MR1P264MB1843B7AE0B4CCCC388231A69ED549@MR1P264MB1843.FRAP264.PROD.OUTLOOK.COM>
x-ms-oob-tlc-oobclassifiers: OLM:148;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: /2uVA4NbFyKWhohk+G5rkU74facQpEa3oCoFr/RPD12N14peOV4bL1YBKdPhAHC8UAFWta7fF/W/lgCI4SkEO4UXHkoGJWeTFcrFmqb0A9MsWqEiLNacdyv47yYneEeRLJ4GLzxqbPf1RY1BPkl0JiBQSpPMjw2uKSbunnTrUS+tz7at9nccY8LYkzlXnUi5COPw+ZTZieEIr3zF2UBUO050FdaQNCsPeISm7Zu099qr2qp9CZFceo+6zD2BU78eHHCS+TchjqUbSVG5+KUcQaxO5GPJ5+NUX33s3nWrHzIZEkRv4wzCbi91A5qiBadQJTsjMiQ6f5sGmgMeYWgbwGdmh105FQdQShNV7ulo+tjj5C4frwszBybFMZ9yVIKIYRFHMfjx5RjGbPRds26DzMXjVq0YYkFxNHexXmbyQttsqTvyGad6R/l76uDwA9NsY0j6Df3vwzHD7gFWDzc/WbpbY+w5JcePSoSX/KN70IVzNO6cIS35eZ3rZc+djE4exx40k4KRR9ojAQZWHBuDT7NLrPXWPuEFTx8MB8LozSfhSQngJZ+azhwY9oWsym5fGz1cvPVyv+c2h/5KRj1BS0XQGczicc1Wffvy4ZXcx4cval9pWBnZnhDgiQbcMeP3ACBEK60YivPm59OOmjpGfXS/dEBSZy2N2RfOc48l0XX85sLvK5/z4uL5aAIm4LisJ3gJvfjgJNu98H/NRrtJ7w==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MRZP264MB2988.FRAP264.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(4636009)(366004)(8676002)(76116006)(186003)(6512007)(26005)(38100700002)(86362001)(71200400001)(8936002)(2906002)(122000001)(83380400001)(6506007)(5660300002)(66476007)(66556008)(64756008)(66946007)(66446008)(91956017)(6486002)(508600001)(44832011)(2616005)(54906003)(4326008)(110136005)(36756003)(38070700005)(316002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-1?Q?IaK9BnSneAyTMBVaviN01pe6DAEyJe+Qgh/6fwsr+6YomlF1HIFEjJ8VO4?=
 =?iso-8859-1?Q?yB+l9qNdX5ymIXig8wFMWChfrja2u8Kajx+aHg25Fvxcn3lA71dFA/A8Bv?=
 =?iso-8859-1?Q?iwFqeABOfr5by6EW7cewWUSYEGNg7cLPMnxQAOAdbw2mSkxZfjvIirY4qw?=
 =?iso-8859-1?Q?FKXWLbraRLneKwcr/JVqRLZBhCGREzJb/77eA8AON2UD+MU/zYq1HS++jX?=
 =?iso-8859-1?Q?WTe6j/GthRcPNvEzNa/3jEbIaXly4DmsuWAxh/iTZ5d78p1QKux+JH4NG3?=
 =?iso-8859-1?Q?Ikj7szGNWcM4SqiZ9F1nmXqSdB8olkqfIPStUt3h5O5MiQZjZAsVEaSVPm?=
 =?iso-8859-1?Q?eZqVo4kbaVJZHC8TbzostmowHWiGmQGIxYfQHFbM+17wQxGm8fqfNqmNA6?=
 =?iso-8859-1?Q?3bVkXmiz1Jyfl3zaii4LquXOfG7RzVVy/2X5aEJctg55pEscdeXTVnSNhI?=
 =?iso-8859-1?Q?XP0x3gLyKmBSuLHKvtfoBIcTWumgcrXzVnY01+3t4OLIlfw1TWyJ3Ql9ww?=
 =?iso-8859-1?Q?l80Z0+glFpidOU2hCGFnuDkJl/Q3/H5OnCR5Iz2QvUesE/IefprV+8yW7J?=
 =?iso-8859-1?Q?zfuUC5NIk+p3hJVMcL9zWCtJyqddBPFA5PBAJQN2Cn/coQeAkenxg0aer8?=
 =?iso-8859-1?Q?58DQLIZKhUISLhtY1pIdwHhXdt7gWwRov03VD9N5xxiURIyScpV5S/w4Mn?=
 =?iso-8859-1?Q?hjlnpSDrreeRbB0fPoJJxqyCjAZTfJlmsSopv0aey4c642QW+Fo19sUVDy?=
 =?iso-8859-1?Q?io/FKqo4tkuH/NqnAHxSBHNkRgaYByo/Qb/1c7iqaNM79WpQyouiu8iJtP?=
 =?iso-8859-1?Q?aUR8w89aZJtaaDVPbdGwaJrzcCf4AjLBXy6Zkt09DAXZO5Kt9Li+UzrCgN?=
 =?iso-8859-1?Q?YnfdIrCkGSIBIiDynNP4VZtR+3VTN6XKlm/te999LV/YXrg/Y5gInxjWGG?=
 =?iso-8859-1?Q?EWLnfOFQfg+FfsXHK4qdx99UNFnl257LQlPJo+zQ+WP9Q1LeNYPzTCop7m?=
 =?iso-8859-1?Q?X8UECRgI0NV8MF0dqvRCDvYvj/9SABsgGhh+H2n7JOiuUYuMLBa/jeC6mz?=
 =?iso-8859-1?Q?tKbvnWDvh0TQw+FO61Bwv+avompjaxbAqv8mGLSWLswB1jwfVK8HBOG3ae?=
 =?iso-8859-1?Q?UCBzNjduDSNZd15ws5YggGYdwvgjr1OqU6fzi0FEr3ibRU4FK6GanG4v7W?=
 =?iso-8859-1?Q?ACvx6E+mdLmNUqCg4VNU3Fi7SuT2Inf1mC8zWRkJAQvem0aVM2u7p+eGWC?=
 =?iso-8859-1?Q?28KbnOP+d4w9tWaICYL5flnJYqAOm6q4BoSvwMi6HTXvUVtHEgED+OYHG8?=
 =?iso-8859-1?Q?ofO0GG/1GTUto/dv3uJgY15LHNe0GozPYtEKjczEIOQg84d/Lbw17iZZtu?=
 =?iso-8859-1?Q?OqTQjlMqbDj3Z1Wxc+gXJl387QR+MSojHV3Yy7KrXmOzJR4wDeua8ECsFa?=
 =?iso-8859-1?Q?R8x4RZHRbiSDSkUqkrxO2Y6QCKFx75qXdHNya49dVt5BzqIy/j4TrK4E8J?=
 =?iso-8859-1?Q?nsoKy7ncWyjvOtjzIy+GvhsdiP3f0e1ySC5xOyGd1bnTDBmyrJE1u7YzfE?=
 =?iso-8859-1?Q?i5nOL0Zh7cXeQTv74yDKkZuxrOXQuM2kvBtYRJWhscDMn2/awKClc4SN+x?=
 =?iso-8859-1?Q?CnJK2RAD3EC5JO7gd0iEkCZDUu5LFNhJ4oyQBs6k1y6VrP5OQ/ChCdmMXL?=
 =?iso-8859-1?Q?O9IqJf2Cp6my6lsyMiOFnArJDGuDUDpLmo5WErt5ChwcfcLXjun1erub9z?=
 =?iso-8859-1?Q?usUSIfT8wz3s5ktlFu55SOVYg=3D?=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: csgroup.eu
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MRZP264MB2988.FRAP264.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-Network-Message-Id: 366ce395-8949-46f2-8c4d-08d9d750b310
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Jan 2022 11:26:25.0416
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 9914def7-b676-4fda-8815-5d49fb3b45c8
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 2WeF0xuIdxSEzo4DhaGuMakrzaYaD6h2M3e2pmt8s8YlUIUe2zpGObRamP0nB/LUPY9I+UwmraEMfnXb4MBzJ0gCobctz/0hGuqWV8U68Ws=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MR1P264MB1843
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Commit 770cec16cdc9 ("powerpc/audit: Simplify syscall_get_arch()")
and commit 898a1ef06ad4 ("powerpc/audit: Avoid unneccessary #ifdef
in syscall_get_arguments()")
replaced test_tsk_thread_flag(task, TIF_32BIT)) by is_32bit_task().

But is_32bit_task() applies on current task while be want the test
done on task 'task'

So add a new macro is_tsk_32bit_task() to check any task.

Reported-by: Dmitry V. Levin <ldv@altlinux.org>
Fixes: 770cec16cdc9 ("powerpc/audit: Simplify syscall_get_arch()")
Fixes: 898a1ef06ad4 ("powerpc/audit: Avoid unneccessary #ifdef in syscall_get_arguments()")
Cc: stable@vger.kernel.org
Signed-off-by: Christophe Leroy <christophe.leroy@csgroup.eu>
---
v2: Add new macro and handle second erroneous use of is_32bit_task().
---
 arch/powerpc/include/asm/syscall.h     | 4 ++--
 arch/powerpc/include/asm/thread_info.h | 2 ++
 2 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/arch/powerpc/include/asm/syscall.h b/arch/powerpc/include/asm/syscall.h
index 52d05b465e3e..25fc8ad9a27a 100644
--- a/arch/powerpc/include/asm/syscall.h
+++ b/arch/powerpc/include/asm/syscall.h
@@ -90,7 +90,7 @@ static inline void syscall_get_arguments(struct task_struct *task,
 	unsigned long val, mask = -1UL;
 	unsigned int n = 6;
 
-	if (is_32bit_task())
+	if (is_tsk_32bit_task(task))
 		mask = 0xffffffff;
 
 	while (n--) {
@@ -105,7 +105,7 @@ static inline void syscall_get_arguments(struct task_struct *task,
 
 static inline int syscall_get_arch(struct task_struct *task)
 {
-	if (is_32bit_task())
+	if (is_tsk_32bit_task(task))
 		return AUDIT_ARCH_PPC;
 	else if (IS_ENABLED(CONFIG_CPU_LITTLE_ENDIAN))
 		return AUDIT_ARCH_PPC64LE;
diff --git a/arch/powerpc/include/asm/thread_info.h b/arch/powerpc/include/asm/thread_info.h
index 5725029aaa29..d6e649b3c70b 100644
--- a/arch/powerpc/include/asm/thread_info.h
+++ b/arch/powerpc/include/asm/thread_info.h
@@ -168,8 +168,10 @@ static inline bool test_thread_local_flags(unsigned int flags)
 
 #ifdef CONFIG_COMPAT
 #define is_32bit_task()	(test_thread_flag(TIF_32BIT))
+#define is_tsk_32bit_task(tsk)	(test_tsk_thread_flag(tsk, TIF_32BIT))
 #else
 #define is_32bit_task()	(IS_ENABLED(CONFIG_PPC32))
+#define is_tsk_32bit_task(tsk)	(IS_ENABLED(CONFIG_PPC32))
 #endif
 
 #if defined(CONFIG_PPC64)
-- 
2.33.1
